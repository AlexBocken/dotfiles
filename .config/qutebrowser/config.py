import dracula.draw

# Load existing settings made via :set
config.load_autoconfig()

#Setting Dark mode
#config.set("colors.webpage.darkmode.enabled", True)

dracula.draw.blood(c, {
    'spacing': {
        'vertical': 0,
        'horizontal': 0
    }
})

config.bind(',tr', 'config-cycle content.user_stylesheets ~/src/solarized-everything-css/css/dark/dark-all-sites.css ""')
config.bind(',dr', 'config-cycle content.user_stylesheets ~/src/solarized-everything-css/css/darculized/darculized-all-sites.css ""')
config.bind(',ap', 'config-cycle content.user_stylesheets ~/src/solarized-everything-css/css/apprentice/apprentice-all-sites.css ""')
config.bind(',gv', 'config-cycle content.user_stylesheets ~/src/solarized-everything-css/css/gruvbox/gruvbox-all-sites.css ""')
config.bind(',dd', 'config-cycle content.user_stylesheets ~/src/solarized-everything-css/css/solarized-dark/solarized-dark-all-sites.css ""')
config.bind(',nd', 'config-cycle content.user_stylesheets ~/src/solarized-everything-css/css/nord/nord.css ""')
