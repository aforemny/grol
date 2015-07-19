module Serialize where

import Item
import Model exposing (..)

import Json.Decode as Decode
import Json.Encode as Encode

encode : Model -> Encode.Value
encode m =
  let encodeItem (id, i) =
        Encode.object
          [ ("description", Encode.string i.description)
          , ("amount", Encode.int i.amount)
          , ("unit", Encode.string (Item.unitToString i.unit))
          , ("id", Encode.int id)
          ]

  in
    Encode.object
      [ ("items", Encode.list (List.map encodeItem m.items))
      , ("nextID", Encode.int m.nextID)
      , ("amount", Encode.int m.amount)
      , ("unit", Encode.string (Item.unitToString m.unit))
      , ("descr", Encode.string m.descr)
      ]


decode : Decode.Decoder Model
decode =
  let
    model i n a u d =
      { items = i
      , nextID = n
      , amount = a
      , unit = u
      , descr = d
      }
    decodeItem : Decode.Decoder (ID, Item.Model)
    decodeItem =
      Decode.object4
        (\d a u id -> (id, { description = d
                           , amount = a
                           , unit = u
                           }
                      )
        )
        (Decode.at ["description"] Decode.string)
        (Decode.at ["amount"] Decode.int)
        (Decode.at ["unit"] (Decode.map Item.stringToUnit Decode.string))
        (Decode.at ["id"] (Decode.int))
  in
    Decode.object5
      model
      (Decode.at ["items"] (Decode.list decodeItem))
      (Decode.at ["nextID"] Decode.int)
      (Decode.at ["amount"] Decode.int)
      (Decode.at ["unit"] (Decode.map Item.stringToUnit Decode.string))
      (Decode.at ["descr"] Decode.string)

