module Components.Content exposing (Content, ContentInfo, decoder)

import Json.Decode as Decode
import Json.Encode as Encode
import Debug exposing (log)
type alias Content =
    {
      resultCount: Int,
      results: List ContentInfo
    }

type alias ContentInfo =
    {
      artistName: String
    }

decoder : Decode.Decoder Content
decoder =
    log("dec")
    Decode.map2 Content
        (Decode.field "resultCount" Decode.int)
        (Decode.field "results" (Decode.list decoderContentInfo))

-- encode : Content -> Encode.Value
-- encode сontent =
--     let
--         attributes =
--             [ ( "resultCount", Encode.int сontent.resultCount )
--             , ( "results", Encode.array сontent.results)
--             ]
--     in
--     Encode.object attributes

decoderContentInfo : Decode.Decoder ContentInfo
decoderContentInfo =
  log("decoderContentInfo")
    Decode.map ContentInfo
        (Decode.field "artistName" Decode.string)