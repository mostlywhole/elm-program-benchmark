module Types exposing (Model, Msg(..), Spot(..), Benchmark(..), Size(..))

import Time exposing (Time)


type alias Model =
    { g : List String
    , benchmarkProgramSmall : ( Time, Time )
    , benchmarkProgramBig : ( Time, Time )
    , benchmarkRecursiveSmall : ( Time, Time )
    , benchmarkRecursiveBig : ( Time, Time )
    }


type Msg
    = SmallChildMsg
    | BigChildMsg
    | SmallChildMsgRecursive
    | BigChildMsgRecursive
    | GetTime Benchmark Spot Time
    | StartBenchmark Benchmark
    | ReportBenchmark Benchmark
    | RecvAppend ( String, Bool )


type Benchmark
    = BMProgram Size
    | BMRecursive Size


type Size
    = Big
    | Small


type Spot
    = Before
    | After
