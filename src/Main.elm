module Main exposing (main)

{-| # Show the Local Weather
----------------------------
**Objective**: Build an app that is functionally similar to this:
<http://codepen.io/FreeCodeCamp/full/bELRjV>.

1. **Rule #1:** Don't look at the example project's code. Figure it out for
   yourself.

2. **Rule #2:** Fulfill the below [user
   stories](https://en.wikipedia.org/wiki/User_story). Use whichever libraries
   or APIs you need. Give it your own personal style.

3. **User Story:** I can see the weather in my current location.

4. **User Story:** I can see a different icon or background image (e.g. snowy
   mountain, hot desert) depending on the weather.

5. **User Story:** I can push a button to toggle between Fahrenheit and
   Celsius.

6. We recommend using the [Open Weather
   API](https://openweathermap.org/current#geo). This will require creating a
   free API key. Normally you want to avoid exposing API keys on CodePen, but
   we haven't been able to find a keyless API for weather.

<https://www.freecodecamp.com/challenges/show-the-local-weather>

# Main
@docs main

-}

import Html.App
import Weather


{-| Main entry point. -}
main : Program Never
main =
  Html.App.program
    { init = Weather.init
    , view = Weather.view
    , update = Weather.update
    , subscriptions = Weather.subscriptions
    }
