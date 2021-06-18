module Models.Content exposing (Content, ContentInfo, decoder)

import Json.Decode as Decode
import Http exposing (track)


type alias Content =
    {
      resultCount: Int,
      results: List ContentInfo
    }

type alias ContentInfo =
    {
      artistName: String,
      artworkUrl100: String,
      currency: String,
      trackId: Int,
      trackName: String
    }

decoder : Decode.Decoder Content
decoder =
    Decode.map2 Content
        (Decode.field "resultCount" Decode.int)
        (Decode.field "results" (Decode.list decoderContentInfo))

decoderContentInfo : Decode.Decoder ContentInfo
decoderContentInfo =
    Decode.map5 ContentInfo
        (Decode.field "artistName" Decode.string)
        (Decode.field "artworkUrl100" Decode.string)
        (Decode.field "currency" Decode.string)
        (Decode.field "trackId" Decode.int)
        (Decode.field "trackName" Decode.string)