# Roblox Gatherer SDK

Current version: 0.1.0

This package was developed by MetaverseGroup and should be used to track events and logs inside your Roblox games. It was created to integrate with the Helixworlds System, so you can visit `app.helixworlds.io` to see the gathered analytics.

Visit the website, create an account, an organization, your game, and get the credentials to start tracking your users and getting knowledge to improve and make your app more successful.

You can also create custom events and track them using this package, being able to measure different kinds of actions and get good insights about your games and items!

This package contains 2 ModuleScripts that you can use to connect your game with the Gatherer API seamlessly.

## Installation and Usage

### Setup

Clone the repository:

   ```bash
   git clone https://github.com/MetaverseGroup/roblox-gatherer-sdk.git
   ```

Install [aftman](https://github.com/LPGhatguy/aftman)

Install the components

```
aftman install
```

### VSCode Extension

Install the Rojo VSCode Extension

Follow this [Rojo Doc (Building your Place)](https://rojo.space/docs/v7/getting-started/new-game/#building-your-place) to Build the package

Open Roblox Studio and open the build file

Follow this [Rojo Doc (Live Syncing)](https://rojo.space/docs/v7/getting-started/new-game/#live-syncing-into-studio) to make updates and see the changes reflected in realtime inside Roblox Studio (You need the [Rojo Plugin](https://create.roblox.com/store/asset/13916111004/Rojo?externalSource=www) installed)

### Local Server Syncing

Install the plugin

```
rojo plugin install
```

## Development

### Build 

```
rojo build -o gatherer.rbxlx
```

