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
      kind: String,
      artworkUrl100: String,
      collectionName: String,
      collectionViewUrl: String,
      currency: String,
      trackPrice: String,
      trackName: String
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
    Decode.map8 ContentInfo
        (Decode.field "artistName" Decode.string)
        (Decode.field "kind" Decode.string)
        (Decode.field "artworkUrl100" Decode.string)
        (Decode.field "collectionName" Decode.string)
        (Decode.field "collectionViewUrl" Decode.string)
        (Decode.field "currency" Decode.string)
        (Decode.field "trackPrice" Decode.string)
        (Decode.field "trackName" Decode.string)