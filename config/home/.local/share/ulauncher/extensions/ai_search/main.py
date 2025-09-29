# import webbrowser
import os
import shlex
from ulauncher.api.client.Extension import Extension
from ulauncher.api.client.EventListener import EventListener

from ulauncher.api.shared.event import KeywordQueryEvent, ItemEnterEvent
from ulauncher.api.shared.item.ExtensionResultItem import ExtensionResultItem
from ulauncher.api.shared.action.RenderResultListAction import RenderResultListAction
from ulauncher.api.shared.action.HideWindowAction import HideWindowAction
from ulauncher.api.shared.action.RunScriptAction import RunScriptAction


class AISearchExtension(Extension):
    def __init__(self):
        super().__init__()
        self.subscribe(KeywordQueryEvent, KeywordQueryEventListener())


class KeywordQueryEventListener(EventListener):
    def on_event(self, event, extension):  # type: ignore
        # Get the query from the user
        query = event.get_argument()
        script_path_grok = extension.preferences["grok_script_path"]
        script_path_gemini = extension.preferences["gemini_script_path"]

        # If there's no query yet, show a placeholder message
        if not query:
            return RenderResultListAction(
                [
                    ExtensionResultItem(
                        icon="images/icon.png",
                        name="AI Search",
                        description="Enter your search term...",
                        on_enter=HideWindowAction(),
                    )
                ]
            )

        items = []

        # Check and add Grok item
        if os.path.exists(script_path_grok):
            grok_item = ExtensionResultItem(
                icon="images/icon.png",
                name=f"Search for '{query}' with Grok",
                description="Open Grok search results in your browser",
                on_enter=RunScriptAction(f"sh {script_path_grok} {shlex.quote(query)}"),
            )
            items.append(grok_item)
        else:
            items.append(
                ExtensionResultItem(
                    icon="images/icon.png",
                    name="Grok Script Not Found",
                    description=f"Script not found at {script_path_grok}",
                    on_enter=HideWindowAction(),
                )
            )

        # Check and add Gemini item
        if os.path.exists(script_path_gemini):
            gemini_item = ExtensionResultItem(
                icon="images/icon.png",
                name=f"Search for '{query}' with Gemini",
                description="Open Gemini search results in your browser",
                on_enter=RunScriptAction(
                    f"sh {script_path_gemini} {shlex.quote(query)}"
                ),
            )
            items.append(gemini_item)
        else:
            items.append(
                ExtensionResultItem(
                    icon="images/icon.png",
                    name="Gemini Script Not Found",
                    description=f"Script not found at {script_path_gemini}",
                    on_enter=HideWindowAction(),
                )
            )

        return RenderResultListAction(items)


if __name__ == "__main__":
    AISearchExtension().run()
