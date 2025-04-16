#!/usr/bin/env -S uv run --script

import json
from subprocess import Popen, PIPE


def watchWorkspaces():
    with Popen(["niri", "msg", "--json", "event-stream"], stdout=PIPE) as eventStream:
        while True:
            event = json.loads(eventStream.stdout.readline())
            if "WorkspacesChanged" in event:
                workspaces = event["WorkspacesChanged"]["workspaces"]
                outputs = {workspace["output"] for workspace in workspaces}
                yield outputs


def startWallpaper(output: str):
    return Popen(
        [
            "mpvpaper",
            "-o",
            "no-audio --loop-playlist shuffle",
            output,
            "/home/daniel/Videos/wallpaper/",
        ]
    )


def main():
    lastOutputs = set()
    children = []
    for outputs in watchWorkspaces():
        if outputs != lastOutputs:
            lastOutputs = outputs
            for child in children:
                child.kill()
            children = [startWallpaper(output) for output in outputs]


if __name__ == "__main__":
    main()
