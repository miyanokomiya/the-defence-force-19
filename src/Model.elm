module Model exposing (Bullet, Enemy, Model, Sight)


type alias Model =
    { enemies : List Enemy
    , bullets : List Bullet
    , sight : Sight
    , cooldown: Float
    }


type alias Enemy =
    { x : Float
    , y : Float
    }


type alias Bullet =
    {}


type alias Sight =
    { x : Float
    , y : Float
    }
