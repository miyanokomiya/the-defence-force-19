module Model exposing
    ( Bullet
    , BulletHole
    , Enemy
    , EnemyType(..)
    , Model
    , Sight
    , maxEnemyAtLevel
    )

import Random


type alias Model =
    { seed : Random.Seed
    , level : Int
    , deleteCount : Int
    , enemies : List Enemy
    , bullets : List Bullet
    , sight : Sight
    , cooldown : Float
    , bulletHoles : List BulletHole
    , enemyPopCooldown : Float
    }


type EnemyType
    = EnemyA
    | EnemyB
    | EnemyC


type alias Enemy =
    { x : Float
    , y : Float
    , direction : Float
    , speed : Float
    , type_ : EnemyType
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


maxEnemyAtLevel : Int -> Int
maxEnemyAtLevel level =
    20 * level
