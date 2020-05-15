module Main exposing (..)

import Model exposing (Model)
import Playground exposing (..)
import View


initModel : Model
initModel =
    { enemies = [ { x = -30, y = 80 }, { x = 30, y = 80 } ]
    , bullets = initBullets
    , sight = { x = 0, y = 0 }
    , cooldown = 0
    , bulletHoles = []
    }


initBullets : List Model.Bullet
initBullets =
    [ {}, {}, {}, {}, {}, {} ]


initBulletHole : Float -> Float -> Model.BulletHole
initBulletHole x y =
    { x = x, y = y, life = 1 }


main =
    game view update initModel


view : Computer -> Model -> List Shape
view computer model =
    (model.enemies
        |> List.map
            (\e -> View.enemy e)
    )
        ++ (model.bullets
                |> List.indexedMap
                    (\i bul -> View.bullet computer.screen i bul)
           )
        ++ (model.bulletHoles
                |> List.map
                    (\hole -> View.bulletHole hole)
           )
        ++ [ View.cooldown computer.screen model.cooldown
           , View.sight model.sight
           ]


update : Computer -> Model -> Model
update computer model =
    let
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
    in
    { model
        | sight = nextSight
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
    }
