module State exposing (update, init, sub)

import Types exposing (Model, Msg(..), Spot(..), Benchmark(..), Size(..))
import Task exposing (Task)
import Time exposing (Time)


init : ( Model, Cmd Msg )
init =
    ( { g = []
      , benchmarkProgramSmall = ( 0, 0 )
      , benchmarkRecursiveBig = ( 0, 0 )
      , benchmarkProgramBig = ( 0, 0 )
      , benchmarkRecursiveSmall = ( 0, 0 )
      }
    , Cmd.none
    )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        RecvAppend ( data, toggle ) ->
            if List.length model.g < 2000 then
                ( { model | g = data :: model.g }, Task.perform RecvAppend (taskFunction toggle) )
            else
                case toggle of
                    True ->
                        ( { model | g = data :: model.g }, Task.perform (always <| ReportBenchmark (BMProgram Small)) (Task.succeed ()) )

                    False ->
                        ( { model | g = data :: model.g }, Task.perform (always <| ReportBenchmark (BMProgram Big)) (Task.succeed ()) )

        SmallChildMsg ->
            if List.length model.g < 2000 then
                ( { model | g = "item" :: model.g }, Task.perform RecvAppend (taskFunction True) )
            else
                ( { model | g = "item" :: model.g }, Task.perform (always <| ReportBenchmark (BMProgram Small)) (Task.succeed ()) )

        BigChildMsg ->
            if List.length model.g < 2000 then
                ( { model | g = bigItem :: model.g }, Task.perform RecvAppend (taskFunction False) )
            else
                ( { model | g = bigItem :: model.g }, Task.perform (always <| ReportBenchmark (BMProgram Big)) (Task.succeed ()) )

        SmallChildMsgRecursive ->
            if List.length model.g < 2000 then
                update SmallChildMsgRecursive { model | g = "item" :: model.g }
            else
                ( { model | g = "item" :: model.g }, Task.perform (always <| ReportBenchmark (BMRecursive Small)) (Task.succeed ()) )

        BigChildMsgRecursive ->
            if List.length model.g < 2000 then
                update BigChildMsgRecursive { model | g = bigItem :: model.g }
            else
                ( { model | g = bigItem :: model.g }, Task.perform (always <| ReportBenchmark (BMRecursive Big)) (Task.succeed ()) )

        GetTime b s time ->
            case b of
                BMProgram Big ->
                    ( { model | benchmarkProgramBig = updateBenchmark model.benchmarkProgramBig s time }, getCmdMsg b s )

                BMProgram Small ->
                    ( { model | benchmarkProgramSmall = updateBenchmark model.benchmarkProgramSmall s time }, getCmdMsg b s )

                BMRecursive Big ->
                    ( { model | benchmarkRecursiveBig = updateBenchmark model.benchmarkRecursiveBig s time }, getCmdMsg b s )

                BMRecursive Small ->
                    ( { model | benchmarkRecursiveSmall = updateBenchmark model.benchmarkRecursiveSmall s time }, getCmdMsg b s )

        StartBenchmark b ->
            ( { model | g = [] }, getTime b Before )

        ReportBenchmark b ->
            ( model, getTime b After )


sub : Model -> Sub Msg
sub model =
    Sub.none


getCmdMsg : Benchmark -> Spot -> Cmd Msg
getCmdMsg b s =
    case s of
        After ->
            Cmd.none

        Before ->
            case b of
                BMProgram Big ->
                    Task.perform (always BigChildMsg) (Task.succeed ())

                BMProgram Small ->
                    Task.perform (always SmallChildMsg) (Task.succeed ())

                BMRecursive Big ->
                    Task.perform (always BigChildMsgRecursive) (Task.succeed ())

                BMRecursive Small ->
                    Task.perform (always SmallChildMsgRecursive) (Task.succeed ())


getTime : Benchmark -> Spot -> Cmd Msg
getTime b s =
    Task.perform (GetTime b s) Time.now


updateBenchmark : ( Time, Time ) -> Spot -> Time -> ( Time, Time )
updateBenchmark ( time, time2 ) spot time3 =
    case spot of
        Before ->
            ( time3, 0 )

        After ->
            ( time, time3 )


bigItem : String
bigItem =
    "qwertytyuiopasdfghjklzxcvbnmmqazwsxedcrfvtgbyhnujmik,ol.1234567890wazxcesazxcvbhytrdcvbnmkiuygbn m,lopiuygvbnhytrd"


taskFunction : Bool -> Task Never ( String, Bool )
taskFunction size =
    if size then
        Task.succeed ( "test", size )
    else
        Task.succeed ( bigItem, size )
