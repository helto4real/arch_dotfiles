from ulauncher.api.client.Extension import Extension
from ulauncher.api.client.EventListener import EventListener

from ulauncher.api.shared.event import KeywordQueryEvent
from ulauncher.api.shared.item.ExtensionResultItem import ExtensionResultItem
from ulauncher.api.shared.action.RenderResultListAction import RenderResultListAction
from ulauncher.api.shared.action.ExtensionCustomAction import ExtensionCustomAction
from ulauncher.api.shared.action.RunScriptAction import RunScriptAction

import os


class SmartSearchExtension(Extension):
    def __init__(self):
        super().__init__()
        self.subscribe(KeywordQueryEvent, KeywordQueryEventListener())


class KeywordQueryEventListener(EventListener):
    def on_event(self, event, extension):
        # Get the query from the user
        query = event.get_argument()
        script_path = extension.preferences.get(
            "script_path", "/home/thhel/.config/scripts/ulauncher-search.sh"
        )

        # If there's no query yet, show a placeholder message
        if not query:
            return RenderResultListAction(
                [
                    ExtensionResultItem(
                        icon="images/icon.png",
                        name="Google Search",
                        description="Enter your search term...",
                        on_enter=ExtensionCustomAction(None),
                    )
                ]
            )

        # Check if script exists
        if not os.path.exists(script_path):
            return RenderResultListAction(
                [
                    ExtensionResultItem(
                        icon="images/icon.png",
                        name="Error",
                        description=f"Script not found: {script_path}",
                        on_enter=ExtensionCustomAction(None),
                    )
                ]
            )

        # Create the result item to display in Ulauncher
        item = ExtensionResultItem(
            icon="images/icon.png",
            name=f"Search for '{query}'",
            description="Open Google search results in your browser",
            on_enter=RunScriptAction(f'sh {script_path} "{query}"'),
        )

        return RenderResultListAction([item])


if __name__ == "__main__":
    SmartSearchExtension().run()
