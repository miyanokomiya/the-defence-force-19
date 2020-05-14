module View exposing (bullet, cooldown, enemy, sight)

import Model
import Playground


sight : Model.Sight -> Playground.Shape
sight si =
    Playground.group
        [ Playground.image 96 96 "/assets/sight.png"
        ]
        |> Playground.move si.x si.y


enemy : Model.Enemy -> Playground.Shape
enemy en =
    Playground.square Playground.red 40
        |> Playground.move en.x en.y


bullet : Playground.Screen -> Int -> Model.Bullet -> Playground.Shape
bullet screen index _ =
    let
        h =
            16
    in
    Playground.rectangle Playground.blue 40 h
        |> Playground.move (screen.right - 50) (toFloat (index * 20) + h / 2 + 30 + screen.bottom)


cooldown : Playground.Screen -> Float -> Playground.Shape
cooldown screen t =
    let
        h =
            100

        scaledH =
            h * (1 - t)
    in
    Playground.group
        [ Playground.rectangle Playground.blue 10 h
            |> Playground.move (screen.right - 80) (30 + h / 2 + screen.bottom)
            |> Playground.fade 0.4
        , Playground.rectangle Playground.blue 10 scaledH
            |> Playground.move (screen.right - 80) (30 + scaledH / 2 + screen.bottom)
        ]
