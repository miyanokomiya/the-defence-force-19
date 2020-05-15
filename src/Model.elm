module Model exposing (Bullet, BulletHole, Enemy, Model, Sight)


type alias Model =
    { enemies : List Enemy
    , bullets : List Bullet
    , sight : Sight
    , cooldown : Float
    , bulletHoles : List BulletHole
    }


type alias Enemy =
    { x : Float
    , y : Float
    }


type alias Bullet =
    {}


type alias BulletHole =
    { x : Float
    , y : Float
    , life : Float
    }


type alias Sight =
    { x : Float
    , y : Float
    }
