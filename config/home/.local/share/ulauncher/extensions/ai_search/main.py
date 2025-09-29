# import webbrowser
from ulauncher.api.client.Extension import Extension
from ulauncher.api.client.EventListener import EventListener

from ulauncher.api.shared.event import KeywordQueryEvent, ItemEnterEvent
from ulauncher.api.shared.item.ExtensionResultItem import ExtensionResultItem
from ulauncher.api.shared.action.RenderResultListAction import RenderResultListAction
# from ulauncher.api.shared.action.HideWindowAction import HideWindowAction

# from ulauncher.api.shared.action.OpenUrlAction import OpenUrlAction
# from ulauncher.api.shared.action.OpenAction import OpenAction
# from ulauncher.api.shared.action.ExtensionCustomAction import ExtensionCustomAction
from ulauncher.api.shared.action.RunScriptAction import RunScriptAction


class GoogleSearchExtension(Extension):
    def __init__(self):
        super().__init__()
        self.subscribe(KeywordQueryEvent, KeywordQueryEventListener())


class KeywordQueryEventListener(EventListener):
    def on_event(self, event, extension):
        # Get the query from the user
        query = event.get_argument()
        script_path_grok = "/home/thhel/.config/scripts/ulauncher-ai-search-grok.sh"
        script_path_gemini = "/home/thhel/.config/scripts/ulauncher-ai-search-gemini.sh"

        # If there's no query yet, show a placeholder message
        if not query:
            return RenderResultListAction(
                [
                    ExtensionResultItem(
                        icon="images/icon.png",
                        name="AI Search",
                        description="Enter your search term...",
                        on_enter=None,
                    )
                ]
            )

        # Create the result item to display in Ulauncher
        grok_item = ExtensionResultItem(
            icon="images/icon.png",
            name=f"Search for '{query}'",
            description="Open Grok search results in your browser",
            on_enter=RunScriptAction(f'sh {script_path_grok} "{query}"'),
        )

        gemini_item = ExtensionResultItem(
            icon="images/icon.png",
            name=f"Search for '{query}'",
            description="Open Gemini search results in your browser",
            on_enter=RunScriptAction(f'sh {script_path_gemini} "{query}"'),
        )

        return RenderResultListAction([grok_item, gemini_item])


if __name__ == "__main__":
    GoogleSearchExtension().run()
