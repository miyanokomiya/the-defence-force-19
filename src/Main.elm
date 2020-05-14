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
    }


initBullets : List Model.Bullet
initBullets =
    [ {}, {}, {}, {}, {}, {} ]


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
        ++ [ View.cooldown computer.screen model.cooldown
           , View.sight model.sight
           ]


update : Computer -> Model -> Model
update computer model =
    let
        fire =
            computer.keyboard.space && model.cooldown == 0

        nextBullets =
            if fire then
                List.drop 1 model.bullets

            else if List.length model.bullets == 0 && model.cooldown == 0 then
                initBullets

            else
                model.bullets
    in
    { model
        | sight =
            { x = model.sight.x + toX computer.keyboard * 5
            , y = model.sight.y + toY computer.keyboard * 5
            }
        , bullets = nextBullets
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
