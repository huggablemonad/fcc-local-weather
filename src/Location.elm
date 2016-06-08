module Location exposing
  ( Location
  , get
  )

{-| Find out the user's location via their IP address.

# Location
@docs Location

# Get Current Location
@docs get

-}

import Http
import Json.Decode as Json exposing ((:=))
import Task exposing (Task)


{-| Details of the user's location.
-}
type alias Location =
  { city : String
  , countryCode : String
  , latitude: Float
  , longitude : Float
  }


{-| Return the user's location.

This function makes a request to <https://ipapi.co/json/> and expects a JSON
response.
-}
get : Task Http.Error Location
get =
  Http.get location "https://ipapi.co/json/"


{-| Decode the location information to a `Location` record. -}
location : Json.Decoder Location
location =
  Json.object4 Location
    ("city" := Json.string)
    ("country" := Json.string)
    ("latitude" := Json.float)
    ("longitude" := Json.float)
