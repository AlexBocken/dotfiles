import dracula.draw

# Load existing settings made via :set
config.load_autoconfig(False)

c.auto_save.session = False
c.backend = "webengine"
c.bindings.commands = { "normal":
         {
            ",C": "spawn -d st castyt {url}",
            ",S": "spawn -d mpvallvids {url}",
            ",V": "spawn -d startmpv {url}",
            ",X": "spawn -d dmenuhandler {url}",
            ",c": "hint links spawn -d st castyt {hint-url}",
            ",s": "hint links spawn -d mpvallvids {hint-url}",
            ",v": "hint links spawn -d startmpv {hint-url}",
            ",x": "hint links spawn -d dmenuhandler {hint-url}",
            "aO": "download-open;; download-remove;; close",
            "ao": "download-open;; download-remove",
            "ar": "download-remove"
         }
        }

c.colors.webpage.preferred_color_scheme = "dark"
c.completion.scrollbar.width = 1
c.content.blocking.method = "both"
c.content.desktop_capture = "ask"
c.content.fullscreen.window = False

c.content.headers.user_agent = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/109.0.0.0 Safari/537.36"

c.content.javascript.enabled = True
c.content.local_content_can_access_remote_urls = True
c.content.notifications.presenter = "libnotify"

from os.path import expanduser
c.downloads.location.directory = expanduser("~")
c.downloads.location.prompt = False
c.downloads.location.suggestion = "path"
c.downloads.open_dispatcher = "rifle {}"
c.downloads.position = "top"
c.downloads.remove_finished = 1000000

c.editor.command = [ "st", "nvim", "-f", "'{file}'", "-c", "normal", "{line}G{column}" ]
c.fileselect.folder.command = [ "st", "-e", "ranger", "--choosedir={}" ]
c.fileselect.handler = "external"
c.fileselect.multiple_files.command =  [ "st", "-e", "ranger", "--choosefiles={}" ]
c.fileselect.single_file.command =  [ "st", "-e", "ranger", "--choosefile={}" ]

c.fonts.default_size = "18pt"
c.fonts.statusbar = "default_size default_family"
c.fonts.web.size.default = 16
c.fonts.web.size.default_fixed = 13

c.hints.border = "2px solid #E3BE23"
c.prompt.filebrowser = False
c.qt.highdpi = False
c.spellcheck.languages = ["en-US", "de-DE"]

c.statusbar.show = "always"
c.tabs.show = "never"
c.tabs.tabs_are_windows = True

local_startpage : str = "https://bocken.org"
c.url.start_pages = local_startpage
c.url.default_page = local_startpage

c.url.open_base_url = True

searchengines = {
      "brave": "https://search.brave.com/search?q={}&source=web",
      "cactus": "https://latin.cactus2000.de/index.php?q={}",
      "ddg": "https://duckduckgo.com/?q={}",
      "dw": "https://www.dwds.de/wb/{}",
      "gg": "https://linggle.com/?q={}",
      "jisho": "jisho.org/search/{}",
      "ling": "https://www.linguee.com/english-german/search?source=auto&query={}",
      "nyaa": "nyaa.si/?q={}",
      "oz": "http://www.ozdic.com/collocation-dictionary/{}",
      "re": "https://bocken.org/rezepte/?q={}",
      "yt": "https://www.youtube.com/results?search_query={}"
      }
searchengines["DEFAULT"] = searchengines["brave"]
c.url.searchengines = searchengines

c.zoom.default = "160%"

dracula.draw.blood(c, {
    'spacing': {
        'vertical': 0,
        'horizontal': 0
    }
})
