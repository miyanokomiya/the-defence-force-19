module View exposing (bullet, bulletHole, cooldown, enemy, scoreBoard, sight)

import Model exposing (Model)
import Playground


scoreBoard : Playground.Computer -> Model -> Playground.Shape
scoreBoard com model =
    Playground.group
        [ Playground.words Playground.black
            ("Enemies: "
                ++ String.fromInt (List.length model.enemies)
                ++ " / "
                ++ String.fromInt (Model.maxEnemyAtLevel model.level)
            )
            |> Playground.move -100 0
        , Playground.words Playground.black
            ("Score: "
                ++ String.fromInt model.deleteCount
            )
            |> Playground.move 100 0
        ]
        |> Playground.move 0 (com.screen.top - 16)
        |> Playground.scale 1.5


sight : Model.Sight -> Playground.Shape
sight si =
    Playground.group
        [ Playground.image 96 96 "assets/sight.png"
        ]
        |> Playground.move si.x si.y


enemy : Model.Enemy -> Playground.Shape
enemy en =
    (case en.type_ of
        Model.EnemyA ->
            Playground.image 32 32 "assets/virus_1.png"

        Model.EnemyB ->
            Playground.image 40 40 "assets/virus_2.png"

        Model.EnemyC ->
            Playground.image 48 48 "assets/virus_3.png"
    )
        |> Playground.move en.x en.y


bullet : Playground.Screen -> Int -> Model.Bullet -> Playground.Shape
bullet screen index _ =
    Playground.image 40 40 "assets/bullet.png"
        |> Playground.rotate 44
        |> Playground.move (screen.right - 40) (toFloat (index * 30) + 40 + screen.bottom)


bulletHole : Model.BulletHole -> Playground.Shape
bulletHole hole =
    Playground.image 128 128 "assets/bullet_hole_1.png"
        |> Playground.fade hole.life
        |> Playground.move hole.x hole.y


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
