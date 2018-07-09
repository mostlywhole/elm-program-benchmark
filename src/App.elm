module App exposing (..)

import Html exposing (program)
import State exposing (init, update, sub)
import Types exposing (Model, Msg)
import Views exposing (view)


main : Program Never Model Msg
main =
    program
        { init = init
        , view = view
        , update = update
        , subscriptions = sub
        }
