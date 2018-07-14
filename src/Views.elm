module Views exposing (view)

import Html exposing (Html, div, button, table, tr, td, text, thead, th)
import Html.Lazy exposing (lazy)
import Types exposing (Model, Msg(..), Benchmark(..), Size(..))
import Html.Events exposing (onClick)
import Html.Attributes exposing (style)
import Time exposing (Time)


view : Model -> Html Msg
view model =
    div
        [ style
            [ ( "display", "flex" )
            , ( "flex-direction", "column" )
            , ( "justify-content", "center" )
            , ( "align-items", "center" )
            , ( "height", "300px" )
            ]
        ]
        [ div
            [ style [ ( "align-items", "left" ) ]
            ]
            [ table []
                [ thead []
                    [ tr []
                        [ th [] [ text "Benchmark Type" ]
                        , th [] [ text "Start" ]
                        , th [] [ text "End" ]
                        , th [] [ text "Elapsed" ]
                        ]
                    ]
                , lazy renderBMProgramSmall model.benchmarkProgramSmall
                , lazy renderBMProgramBig model.benchmarkProgramBig
                , lazy renderBMRecursiveSmall model.benchmarkRecursiveSmall
                , lazy renderBMRecursiveBig model.benchmarkRecursiveBig
                ]
            ]
        ]


renderBMProgramSmall : ( Time.Time, Time.Time ) -> Html Msg
renderBMProgramSmall benchmarkProgramSmall =
    tr []
        [ td []
            [ button
                [ style [ ( "float", "left" ) ]
                , onClick (StartBenchmark (BMProgram Small))
                ]
                [ text "run small child msg" ]
            ]
        , td [] [ text <| toString <| Tuple.first benchmarkProgramSmall ]
        , td [] [ text <| toString <| Tuple.second benchmarkProgramSmall ]
        , td [] [ text <| toString <| Tuple.second benchmarkProgramSmall - Tuple.first benchmarkProgramSmall ]
        ]


renderBMProgramBig : ( Time.Time, Time.Time ) -> Html Msg
renderBMProgramBig benchmarkProgramBig =
    tr []
        [ td []
            [ button
                [ style [ ( "float", "left" ) ]
                , onClick (StartBenchmark (BMProgram Big))
                ]
                [ text "run big child msg" ]
            ]
        , td [] [ text <| toString <| Tuple.first benchmarkProgramBig ]
        , td [] [ text <| toString <| Tuple.second benchmarkProgramBig ]
        , td [] [ text <| toString <| Tuple.second benchmarkProgramBig - Tuple.first benchmarkProgramBig ]
        ]


renderBMRecursiveSmall : ( Time.Time, Time.Time ) -> Html Msg
renderBMRecursiveSmall benchmarkRecursiveSmall =
    tr []
        [ td []
            [ button
                [ style [ ( "float", "left" ) ]
                , onClick (StartBenchmark (BMRecursive Small))
                ]
                [ text "run recursive small child msg" ]
            ]
        , td [] [ text <| toString <| Tuple.first benchmarkRecursiveSmall ]
        , td [] [ text <| toString <| Tuple.second benchmarkRecursiveSmall ]
        , td [] [ text <| toString <| Tuple.second benchmarkRecursiveSmall - Tuple.first benchmarkRecursiveSmall ]
        ]


renderBMRecursiveBig : ( Time.Time, Time.Time ) -> Html Msg
renderBMRecursiveBig benchmarkRecursiveBig =
    tr []
        [ td []
            [ button
                [ style [ ( "float", "left" ) ]
                , onClick (StartBenchmark (BMRecursive Big))
                ]
                [ text "run recursive big child msg" ]
            ]
        , td [] [ text <| toString <| Tuple.first benchmarkRecursiveBig ]
        , td [] [ text <| toString <| Tuple.second benchmarkRecursiveBig ]
        , td [] [ text <| toString <| Tuple.second benchmarkRecursiveBig - Tuple.first benchmarkRecursiveBig ]
        ]
