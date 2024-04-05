// ==UserScript==
// @name         photoprism bulkeditor
// @version      0.1
// @description  bulkeditor
// @author       andy@boeckler.org
// @match        https://*/library/browse*
// @match        https://*/library/all*
// @match        https://*/library/albums/*/view*
// @match        https://*/library/favorites*
// @namespace    https://bilder.bocken.org/
// @updateURL    https://gist.github.com/boecko/e2d0effe7c61976c22e6bc0a8ee645c7/raw/photoprismbulkeditor.user.js
// @downloadURL  https://gist.github.com/boecko/e2d0effe7c61976c22e6bc0a8ee645c7/raw/photoprismbulkeditor.user.js
// @grant        none
// ==/UserScript==

(function() {
    'use strict';
   // from https://gist.github.com/stephenchew/b73ecc75b77a84a92fa350048d5ca84f
   //------- START
    const isDefined = (value) => typeof value !== 'undefined' && value !== null;

    /**
 *
 * @returns `true` if the field is set, `false` otherwise
 */
    const updateField = (data, field) => {
        const type = data[field].type;
        const value = data[field].content;

        if (!value) {
            return false;
        }

        const element = document.forms[0].__vue__._data.inputs.find((element) =>
                                                                    element.$el.className.includes(`input-${field}`)
                                                                   );

        switch (type.toLowerCase()) {
            case 'prepend':
                element.internalValue = value + ' ' + element.internalValue;
                break;
            case 'append':
                element.internalValue += ' ' + value;
                break;
            case 'replace':
                element.internalValue = value;
                break;
            default:
                console.error(`'${type}' is not a valid way of updating a field.`);
                return false;
        }

        return true;
    };

    const runBulk = async (data) => {
        const validation = validateData(data);

        if (validation) {
            console.error('There is an error in the data:\n\n' + validation);
            return;
        }

        console.time('bulk-edit');

        try {
            const pause = async (seconds) => new Promise((r) => setTimeout(r, seconds * 500));

            let count = 0;

            do {
                let dirty = false;

                if (window.interrupt) {
                    alert('Execution interrupted by user.');
                    delete window.interrupt;
                    return;
                }

                for (let field of Object.keys(data)) {
                    dirty |= updateField(data, field);
                }

                if (!dirty) {
                    console.warn('No field was set. Nothing has changed.');
                    return;
                }

                const applyButton = document.querySelector('button.action-apply');
                applyButton.click();
                count++;

                const rightButton = document.querySelector('.v-toolbar__items .action-next');
                if (rightButton.disabled) {
                    break;
                }

                await pause(1);
                rightButton.click();
                await pause(1);
            } while (true);

            const doneButton = document.querySelector('button.action-done');
            doneButton.click();

            console.info(`Bulk edited ${count} photos.`);
        } finally {
            console.timeEnd('bulk-edit');
        }
    };

    /**
 * Return LF delimited error message, or `null` if all is good.
 */
    const validateData = (data) => {
        if (!data) {
            return 'No data provided.';
        }

        const error = [];

        if (isDefined(data.day?.content)) {
            const day = parseInt(data.day.content, 10);
            if (isNaN(day) || day < -1 || day > 31 || day === 0) {
                error.push('Day must be between 1 and 31. Set to -1 for "Unknown".');
            }
            data.day.type = 'replace';
        }

        if (isDefined(data.month?.content)) {
            const month = parseInt(data.month.content, 10);
            if (isNaN(month) || month < -1 || month > 12 || month === 0) {
                error.push('Month must be between 1 and 12. Set to -1 for "Unknown".');
            }
            data.month.type = 'replace';
        }

        if (isDefined(data.year?.content)) {
            const year = parseInt(data.year.content, 10);
            const currentYear = new Date().getFullYear();
            if ((isNaN(year) || year < 1750 || year > currentYear) && year !== -1) {
                // 1750 is Photoprism defined year
                error.push('Year must be between 1750 and ' + currentYear + '. Set to -1 for "Unknown".');
            }
            data.year.type = 'replace';
        }

        return error.length > 0 ? error.join('\n') : null;
    };
//------- END

    const runGpsBulkUpdate = async (url) => {
        if(!url) return
        let m = url.match(/@(.*)z/)
        if( !m[1] ) {
            console.warn("URL ist falsch", url)
            return
        }
        let gpsCoords = m[1].split(',')
        let data = {
            latitude: {
                content: gpsCoords[0],
                type: 'replace'
            },
            longitude: {
                content: gpsCoords[1],
                type: 'replace'
            },
            altitude: {
                content: 0,
                type: 'replace'
            }
        }
        if(gpsCoords[2] && gpsCoords[2].match(/^\d+$/)) {
            data.altitude = {
                content: gpsCoords[2],
                type: 'replace'
            }
        }
        console.log('runBulk', data);
        return await runBulk(data);
        // return true;
    }

     const runKeywordBulkUpdate = async () => {
        let keywords = prompt("Keywords?")
        if(!keywords) return
        let data = {
            keywords: {
                content: keywords,
                type: 'append',
            }
        }
        return await runBulk(data);
        // return true;
    }

//------- greasmonkey code
    const BTN_STYLE_1 = 'cursor: pointer; border: solid white'
    const BTN_STYLE_2 = 'cursor: pointer; border: solid white; opacity:0.5'
    const checkBoxes = {}
    const inputs     = {}
    let submitNode = null
    let bulkRunning = false
    async function submitHandler(e) {
        e.preventDefault()
        let bulkData = {}
        for(let name in checkBoxes) {
            if(!checkBoxes[name].checked) continue
            bulkData[name] = {
                content: inputs[name].value,
                type: 'replace'
            }
        }
        if(Object.keys(bulkData).length == 0) return;
        submitNode.disabled = true
        submitNode.setAttribute('style', BTN_STYLE_2);
        bulkRunning = true
        await runBulk(bulkData);
        bulkRunning = false
    }

    function addSubmitIfMissing() {
        const selector = '.input-title input[type=text]'
        let inputNode = document.querySelector(selector)
        if( inputNode==null || inputNode.offsetParent == null) return
        if(inputNode.nextSibling) return

        let newSubmit = document.createElement('input');
        newSubmit.setAttribute('type', 'submit');
        newSubmit.setAttribute('value', 'Bulkchange');
        newSubmit.setAttribute('style', BTN_STYLE_1);
        inputNode.parentNode.append(newSubmit);
        newSubmit.onclick = submitHandler
        submitNode = newSubmit
    }
    function addCheckBoxIfMissing(name) {
        const selector = '.input-' + name + ' input[type=text]'
        let inputNode = document.querySelector(selector)
        // wenn da und nicht unsichtbar
        if( inputNode==null || inputNode.offsetParent == null) return
        if(inputNode.nextSibling) return

        let newCheckBox = document.createElement('input');
        newCheckBox.setAttribute('type', 'checkbox');
        inputNode.parentNode.append(newCheckBox);
        checkBoxes[name] = newCheckBox
        inputs[name] = inputNode
    }

    var checkExistTimer = setInterval(function () {
        if(bulkRunning) return
	addCheckBoxIfMissing('day')
	addCheckBoxIfMissing('month')
	addCheckBoxIfMissing('year')
        addCheckBoxIfMissing('latitude')
        addCheckBoxIfMissing('longitude')
        addCheckBoxIfMissing('altitude')
        addSubmitIfMissing()
    },1000);

    window.runBulk = runBulk
    window.runGpsBulkUpdate = runGpsBulkUpdate
    window.runKeywordBulkUpdate = runKeywordBulkUpdate

})();
