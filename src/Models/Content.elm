module Models.Content exposing (Content, ContentInfo, decoder)

import Json.Decode as Decode
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

decoderContentInfo : Decode.Decoder ContentInfo
decoderContentInfo =
  log("decoderContentInfo")
    Decode.map ContentInfo
        (Decode.field "artistName" Decode.string)