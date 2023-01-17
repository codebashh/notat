# noteapp

### Boilerplate

It's clean boilerplate bundled with basic stuff which make the development very easy.

## Setup

- `npm i -g hygen` (CLI)
- Install these extensions on VS CODE

  - [Flutter](https://marketplace.visualstudio.com/items?itemName=Dart-Code.flutter)
    - This enables to debug flutter in VS code & make dart code readable with colors & syntax.
  - [Dart Data Class Generator Merge](https://marketplace.visualstudio.com/items?itemName=hzgood.dart-data-class-generator)
    - This helps us make data models via few key strokes.


## Get started with codebase

> All the decisions for setting project's architecture has been taken very carefully and

### Themeing
- `lib/configs` this directory holds all UI related configs.

  - `app_dimensions.dart` scalable sizing units.
  - `app_theme.dart` custom themes for light & dart mode.
  - `app.dart` initializes all configs files & exposes some internationalization methods.
    - `App.tr(KEY, context, args: {"argKey", "Value"})`
      - This method simply accepts locale key & map of arguments
      - Add key value arguments like `{key1} {key2}`
    - `App.pl(KEY, context, no, args: {"argKey", "Value"})`
      - pl means plural. you've to create a simple prefix key mapping.
      - no less than or equal to -1 = KEY+neg.
      - no equal to 0 = KEY.
      - no equal to 1 = KEY+one.
      - no greater than 1 = KEY+more.
    - `App.kv(KEY, context, subKey, args: {"argKey", "Value"})`
      - kv means key value. It's build to solve strings like gender etc.
      - have to build locale mappings strings like KEY+subKey.
  - `common_props.dart` holds props like buttons/card radius, shadows etc.
  - `configs.dart` export all files in configs.
  - `space.dart` exposes commons space widgets
    - `Space.x` SizedBox(width: )
    - `Space.y` SizedBox(height: )
    - `Space.h` EdgInsets.symmetric(horizontal: )
    - `Space.v` EdgInsets.symmetric(vertical: )
    - `Space.top` SizedBox(height: Notch Padding top)
    - `Space.bottom` SizedBox(height: Notch Padding bottom)
  - `text_styles.dart` handles app wide uses styles with font & weight.
  - `theme.dart` initialize flutter's default light/dark theme & font family.
  - `ui.dart` exposes screens dimensions, safe area dimensions & responsive breakpoints.

### BloC Architecture

> NOTE: for state management we're using blocs with cubit. For more info on blocs visit [this link](https://pub.dev/packages/flutter_bloc). We're using cubits instead of stream because it removes the extra layer of `mapToState` & `events.dart`. It's somewhat similar to provider.

- `lib/cubits` this directory hold all the app wide shared cubits.

  - `cubits.dart` emits state of loading, success or failed based on try catch block.
  - `data_provider.dart` initiates the API call and parse the response to data model.
  - `repository.dart` parse data as according to API request body.
  - `state.dart` define conditions of states of loading, error & success.

- `lib/models` contains all the consumable data classes via [Dart Data Class Generator Merge](https://marketplace.visualstudio.com/items?itemName=hzgood.dart-data-class-generator) extension.
- `lib/providers` holds any simple shared state which doesn't need to interact with api.


### Front-end UI

- `lib/screens` holds all the screens.
  - `widgets/` holds screen specific widgets which should never be consumed out side of screen's scope. we also split parts of screens into maintainable widgets for better code management.

- `lib/utils` contains utility classes of different sorts like general, forms etc.
- `lib/widgets` contains general purpose widgets consumed by different screens
- `lib/app_routes.dart` Don't edit this it's auto generated when you create a new screen
- `/scripts` some scripts to make development cycle easier via automating some tasks. This scripts aren't directly consumed in app they're depended on `dev_dependencies`

  - `postHygen.dart` is triggered by `hygen` when new screen is generated.
  - `routes.dart` generates named routes in `lib/app_routes.dart` via looping through all the folders in `lib/screens`
  - `utils.dart` internal utils for scripts. shouldn't be consumed in project.