module Models.Content exposing (Content, ContentInfo, decoder)

import Json.Decode as Decode
import Debug exposing (log)
import Html.Attributes exposing (datetime)

type alias Content =
    {
      resultCount: Int,
      results: List ContentInfo
    }

type alias ContentInfo =
    {
      artistName: String,
      artworkUrl100: String,
      currency: String
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
    Decode.map3 ContentInfo
        (Decode.field "artistName" Decode.string)
        (Decode.field "artworkUrl100" Decode.string)
        (Decode.field "currency" Decode.string)