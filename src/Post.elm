module Post exposing (Post)

type alias Post =
  {
    id : Int
  , title : String
  , authorName : String
  , authorUrl : String
  }