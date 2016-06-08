module Weather exposing
  ( Model, init
  , Msg, update
  , subscriptions
  , view
  )

{-| This library contains functions to retrieve the weather at the user's
location.

# Model
@docs Model, init

# Update
@docs Msg, update

# Subscriptions
@docs subscriptions

# View
@docs view

-}

import Html
import Html.Attributes as Html
import Html.Events as Html
import Http
import Location
import Task


{-| Application state. -}
type alias Model =
  { location : String
  , units : Units
  }


{-| Temperature (Celsius / Fahrenheit) and wind speed (m/s / mph) units. -}
type Units
  = SI  -- International System of Units
  | US  -- United States customary units


{-| Initialize the application. -}
init : (Model, Cmd Msg)
init =
  ( Model "loading.html" US
  , getLocation
  )


{-| Messages for updating the application state. -}
type Msg
  = GetWeather
  | FetchSucceed Location.Location
  | FetchFail Http.Error
  | ChangeUnits


{-| Update the application state. -}
update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    GetWeather ->
      (model, getLocation)

    FetchSucceed newWeather ->
      ({model | location = toUrl newWeather}, Cmd.none)

    FetchFail _ ->
      (Model "Fetch failed." (model.units), Cmd.none)

    ChangeUnits ->
      if model.units == SI then
        ({model | units = US}, Cmd.none)

      else
        ({model | units = SI}, Cmd.none)


{-| Return the weather URL for the user's location. -}
toUrl : Location.Location -> String
toUrl loc =
  let lat = "#lat=" ++ toString loc.latitude
      lon = "&lon=" ++ toString loc.longitude
      name = "&name=" ++ loc.city ++ ", " ++ loc.countryCode
  in "https://forecast.io/embed/" ++ lat ++ lon ++ name


{-| Return subscriptions to event sources. -}
subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none


{-| View application state as HTML. -}
view : Model -> Html.Html Msg
view model =
  -- We use two iframes and toggle between them because the iframe doesn't
  -- refresh when its src attribute is changed. It seems particular to the
  -- Forecast Embed because using other values for src works.
  Html.div []
    [ Html.iframe
        [ Html.src model.location
        , cssIframe <| cssToggleDisplay US model.units
        ]
        []
    , Html.iframe
        [ Html.src <| model.location ++ "&units=si"
        , cssIframe <| cssToggleDisplay SI model.units
        ]
        []
    , Html.button
        [Html.onClick ChangeUnits, cssButton]
        [Html.text "Change units"]
    ]


{-| Return the CSS for the weather iframe. -}
cssIframe : String -> Html.Attribute Msg
cssIframe value =
  Html.style
    [ ("border-width", "0")
    , ("display", value)
    , ("height", "245px")
    , ("width", "100%")
    ]


{-| Return the CSS for hiding or showing the weather iframe. -}
cssToggleDisplay : Units -> Units -> String
cssToggleDisplay iframeUnits units =
  if iframeUnits == units then
    "inline"

  else
    "none"


{-| Return the CSS for the button that toggles between units. -}
cssButton : Html.Attribute Msg
cssButton =
  Html.classList
    [ ("btn", True)
    , ("btn-default", True)
    , ("btn-lg", True)
    ]


{-| Return the user's location. -}
getLocation: Cmd Msg
getLocation =
  Task.perform FetchFail FetchSucceed Location.get
