import Item exposing ( Unit )
import Model exposing ( .. ) 
import Serialize exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
import Json.Decode as Decode
import Json.Encode as Encode
import StartApp
import String
import Task exposing ( Task )
import Result
import Debug


port setStorage : Signal String
port setStorage = Signal.map (Encode.encode 0 << encode) model
port getStorage : Maybe String

actions = Signal.mailbox Nothing

address = Signal.forwardTo actions.address Just

decode' s =
  Result.toMaybe (Decode.decodeString decode s)

model = Signal.foldp (\(Just action) model -> update action model) (Maybe.withDefault init (getStorage `Maybe.andThen` decode')) actions.signal


main =
  Signal.map (view address) model


-- UPDATE

type Action
  = NoOp
  | ChangeAmount Int
  | ChangeUnit Unit
  | ChangeDescr String
  | Insert Int Unit String
  | Modify ID Item.Action


update : Action -> Model -> Model
update action model =
  case action of
    NoOp -> model

    ChangeAmount amount ->
      { model | amount <- amount }

    ChangeUnit unit ->
      { model | unit <- unit }

    ChangeDescr descr ->
      { model | descr <- descr }

    Insert a u descr ->
      { model | 
          items <- ( model.nextID, Item.init descr a u ) :: model.items,
          nextID <- model.nextID + 1
      }

    Modify id itemAction ->
      let updateItem (itemID, itemModel) =
        if itemID == id
           then (itemID, Item.update itemAction itemModel)
           else (itemID, itemModel)
      in 
        { model | items <- List.map updateItem model.items }


-- VIEW

view : Signal.Address Action -> Model -> Html
view address model =
  let form = div []
                [ input [ value (toString model.amount)
                        , onChange address (ChangeAmount << parseAmount)
                        ] []
                , select [ value (Item.unitToString model.unit)
                         , onChange address (ChangeUnit << Item.stringToUnit)
                         ] units
                , input [ value model.descr
                        , onChange address ChangeDescr
                        ] []
                , button [ onClick address insert ] [ text "add" ]
                ]
      units = List.map (\u -> option [] [ text (Item.unitToString u) ] )
                        Item.units  
      insert = Insert model.amount model.unit model.descr 
      items = List.map (viewItem address) model.items
  in
    div [] (form :: items)

parseAmount : String -> Int
parseAmount value =
  Maybe.withDefault 0 (Result.toMaybe (String.toInt value))

viewItem : Signal.Address Action -> (ID, Item.Model) -> Html
viewItem address (id, model) =
  Item.view (Signal.forwardTo address (Modify id)) model

onChange : Signal.Address Action -> (String -> Action) -> Attribute
onChange address value =
  on "change" ( Decode.at [ "target", "value" ] Decode.string ) (\s -> Signal.message address (value s) )

