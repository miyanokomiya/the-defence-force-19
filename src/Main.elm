module Main exposing (..)

import Math.Vector2 as Vector2
import Model exposing (Model)
import Playground exposing (..)
import Random
import View


initModel : Model
initModel =
    { seed = Random.initialSeed 1
    , level = 1
    , deleteCount = 0
    , enemies = []
    , bullets = initBullets
    , sight = { x = 0, y = 0 }
    , cooldown = 0
    , bulletHoles = []
    , enemyPopCooldown = 1
    }


initBullets : List Model.Bullet
initBullets =
    [ {}, {}, {}, {}, {}, {} ]


initBulletHole : Float -> Float -> Model.BulletHole
initBulletHole x y =
    { x = x
    , y = y
    , life = 1
    }


main =
    game view update initModel


view : Computer -> Model -> List Shape
view computer model =
    [ Playground.group
        (model.enemies
            |> List.map
                (\e -> View.enemy e)
        )
    , Playground.group
        (model.bullets
            |> List.indexedMap
                (\i bul -> View.bullet computer.screen i bul)
        )
    , Playground.group
        (model.bulletHoles
            |> List.map
                (\hole -> View.bulletHole hole)
        )
    , View.cooldown
        computer.screen
        model.cooldown
    , View.sight model.sight
    , View.scoreBoard computer model
    ]


update : Computer -> Model -> Model
update computer model =
    let
        enemyPopCooldown =
            model.enemyPopCooldown - 1 / 60 / 2

        fire =
            List.length model.bullets > 0 && computer.keyboard.space && model.cooldown <= 0

        nextBullets =
            if fire then
                List.drop 1 model.bullets

            else if List.length model.bullets == 0 && model.cooldown <= 0 then
                initBullets

            else
                model.bullets

        nextSight =
            { x = model.sight.x + toX computer.keyboard * 5
            , y = model.sight.y + toY computer.keyboard * 5
            }

        nextBulletHoles =
            (if fire then
                initBulletHole nextSight.x nextSight.y :: model.bulletHoles

             else
                model.bulletHoles
            )
                |> List.map (\h -> { h | life = h.life - 0.02 })
                |> List.filter (\h -> h.life > 0)

        ( enemiesAfterPop, s1 ) =
            mayPopEnemies computer model.seed model.level enemyPopCooldown model.enemies

        enemiesAfterFire =
            enemiesAfterPop |> List.filter (\e -> isHolesHitEnemy nextBulletHoles e == False)

        deleteCount =
            model.deleteCount + List.length enemiesAfterPop - List.length enemiesAfterFire
    in
    { model
        | deleteCount = deleteCount
        , enemyPopCooldown =
            if enemyPopCooldown <= 0 then
                1

            else
                enemyPopCooldown
        , sight = nextSight
        , bullets = nextBullets
        , bulletHoles = nextBulletHoles
        , cooldown =
            if fire then
                1

            else
                max 0
                    (model.cooldown
                        - (if List.length nextBullets == 0 then
                            0.01

                           else
                            0.05
                          )
                    )
        , enemies =
            enemiesAfterFire
                |> List.map (\e -> moveEnemy computer.screen e)
        , seed = s1
    }


mayPopEnemies : Computer -> Random.Seed -> Int -> Float -> List Model.Enemy -> ( List Model.Enemy, Random.Seed )
mayPopEnemies com seed level cooldown before =
    if List.length before < Model.maxEnemyAtLevel level && cooldown <= 0 then
        let
            ( pop, nextSeed ) =
                popEnemy com seed
        in
        ( before ++ [ pop ], nextSeed )

    else
        ( before, seed )


popEnemy : Computer -> Random.Seed -> ( Model.Enemy, Random.Seed )
popEnemy com seed =
    let
        ( x, s1 ) =
            Random.step (Random.float com.screen.left com.screen.right) seed

        y =
            com.screen.top

        ( direction, s2 ) =
            Random.step (Random.float (pi * 5 / 4) (pi * 7 / 4)) s1

        ( speed, s3 ) =
            Random.step (Random.float 1 5) s2

        ( type_, s4 ) =
            Random.step (Random.uniform Model.EnemyA [ Model.EnemyB, Model.EnemyC ]) s3
    in
    ( { x = x
      , y = y
      , direction = direction
      , speed = speed
      , type_ = type_
      }
    , s4
    )


moveEnemy : Screen -> Model.Enemy -> Model.Enemy
moveEnemy screen before =
    let
        radian =
            if before.y < screen.bottom || screen.top < before.y then
                -before.direction

            else if before.x < screen.left || screen.right < before.x then
                pi - before.direction

            else
                before.direction
    in
    { before
        | direction = radian
        , x = before.x + cos radian * before.speed
        , y = before.y + sin radian * before.speed
    }


isHolesHitEnemy : List Model.BulletHole -> Model.Enemy -> Bool
isHolesHitEnemy holes enemy =
    holes |> List.any (\h -> isHitEnemy h.x h.y enemy)


isHitEnemy : Float -> Float -> Model.Enemy -> Bool
isHitEnemy x y enemy =
    Vector2.distance (Vector2.vec2 x y) (Vector2.vec2 enemy.x enemy.y) < 48
