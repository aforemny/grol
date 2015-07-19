module Item where

import Debug
import Dict
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)


-- MODEL

type alias Model =
  { description : String
  , amount : Int
  , unit : Unit
  }

type Unit
  = None
  | Gram
  | Kilogram
  | Litre
  | Millilitre

units =
  [ None
  , Gram
  , Kilogram
  , Litre
  , Millilitre
  ]

unitToString : Unit -> String
unitToString u =
  case u of
    None -> "x"
    Gram -> "g"
    Kilogram -> "kg"
    Litre -> "l"
    Millilitre -> "ml"

stringToUnit : String -> Unit
stringToUnit s =
  case s of
    "x" -> None
    "g" -> Gram
    "kg" -> Kilogram
    "l" -> Litre
    "ml" -> Millilitre
    _ -> Debug.crash "Item.stringToUnit"

init : String -> Int -> Unit -> Model
init descr a u =
  { description = descr
  , amount = a
  , unit = u
  }


-- UPDATE

type Action
  = NoOp


update : Action -> Model -> Model
update action model =
  case action of
    NoOp -> model


-- VIEW

view : Signal.Address Action -> Model -> Html
view address model =
  div []
    [ div [] [ text (toString model.amount) ]
    , div [] [ text (toString model.unit) ]
    , div [] [ text (toString model.description) ]
    ]
