#!/usr/bin/env bash
# Builds the plugin and regenerates the custom Dalamud repo in this folder.
# Custom repo URL for Dalamud: https://raw.githubusercontent.com/Charlie1361/Cammy/master/repo/pluginmaster.json
set -euo pipefail

cd "$(dirname "$0")/.."
RAW="https://raw.githubusercontent.com/Charlie1361/Cammy/master/repo"

dotnet build -c Release
mkdir -p repo/Cammy
cp bin/Release/Cammy/latest.zip repo/Cammy/latest.zip

jq --arg dl "$RAW/Cammy/latest.zip" --argjson now "$(date +%s)" '[. + {
    RepoUrl: "https://github.com/Charlie1361/Cammy",
    DownloadLinkInstall: $dl,
    DownloadLinkUpdate: $dl,
    DownloadLinkTesting: $dl,
    IsHide: false,
    IsTestingExclusive: false,
    LastUpdate: $now,
    DownloadCount: 0
}]' bin/Release/Cammy/Cammy.json > repo/pluginmaster.json

echo "Updated repo/pluginmaster.json ($(jq -r '.[0].AssemblyVersion' repo/pluginmaster.json))"
