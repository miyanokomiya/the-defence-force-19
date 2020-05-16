module Model exposing (Bullet, BulletHole, Enemy, Model, Sight)

import Random


type alias Model =
    { seed : Random.Seed
    , enemies : List Enemy
    , bullets : List Bullet
    , sight : Sight
    , cooldown : Float
    , bulletHoles : List BulletHole
    }


type alias Enemy =
    { x : Float
    , y : Float
    , direction : Float
    , speed : Float
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
