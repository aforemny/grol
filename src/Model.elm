module Model where

import Item exposing ( Unit )

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode as Json
import StartApp
import String
import Result
import Debug


type alias Model =
  { items : List ( ID, Item.Model )
  , nextID : ID
  , amount : Int
  , unit : Unit
  , descr : String
  }

type alias ID = Int

init : Model
init =
  { items = []
  , nextID = 0
  , amount = 0
  , unit = Item.None
  , descr = ""
  }
