"""Visualizing L-systems using pythons turtle module.
https://en.wikipedia.org/wiki/L-system


Copyright (C) 2019 Sebastian Henz

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see <https://www.gnu.org/licenses/>.
"""


import turtle
import sys


# rulesets:
plant = {
    "rules": {
        "X": "F+[[X]-X]-F[-FX]+X",
        "F": "FF"
    },
    "axiom": "X",
    "turtle_rules": {
        "F": "forward",
        "-": "left",
        "+": "right",
        "[": "save",
        "]": "load",
        "length": 3.5,
        "angle": 25,
        "screen_width": 800,
        "screen_height": 600,
        "startx": 0,
        "starty": -300,
        "start_angle": 90
    },
    "n_iterations": 6
}
dragon_curve = {
    "rules": {
        "X": "X+YF+",
        "Y": "-FX-Y"
    },
    "axiom": "FX",
    "turtle_rules": {
        "F": "forward",
        "-": "left",
        "+": "right",
        "[": "save",
        "]": "load",
        "length": 5,
        "angle": 90,
        "screen_width": 800,
        "screen_height": 600,
        "startx": 100,
        "starty":160,
        "start_angle": 90
    },
    "n_iterations": 13
}
sierpinski_triangle = {
    "rules": {
        "F": "F-G+F+G-F",
        "G": "GG"
    },
    "axiom": "F-G-G",
    "turtle_rules": {
        "F": "forward",
        "G": "forward",
        "-": "right",
        "+": "left",
        "length": 15,
        "angle": 120,
        "screen_width": 800,
        "screen_height": 600,
        "startx": -240,
        "starty": -200,
        "start_angle": 60
    },
    "n_iterations": 5
}


class Lsystem:
    def __init__(self, rules, turtle_rules, axiom, n_iterations):
        self.rules = rules
        self.turtle_rules = turtle_rules
        self.sentence = axiom
        self.rule_translator = {
            "forward": self.forward,
            "left": self.left,
            "right": self.right,
            "save": self.save,
            "load": self.load
        }
        self.distance = turtle_rules["length"]
        self.angle = turtle_rules["angle"]  # degrees
        self.states = []
        self.screen = turtle.Screen()
        self.screen.setup(
            width=turtle_rules["screen_width"],
            height=turtle_rules["screen_height"]
        )
        self.t = turtle.Turtle(visible=False)
        self.screen.tracer(0)
        self.t.penup()
        self.t.setx(turtle_rules["startx"])
        self.t.sety(turtle_rules["starty"])
        self.t.setheading(turtle_rules["start_angle"])
        self.t.pendown()

        self.iterate(n_iterations)
        self.draw()
        self.screen.tracer(1)
        self.screen.onkey(sys.exit, "Escape")
        self.screen.listen()
        self.screen.mainloop()

    def forward(self):
        self.t.forward(self.distance)

    def right(self):
        self.t.right(self.angle)

    def left(self):
        self.t.left(self.angle)

    def save(self):
        self.states.append((self.t.position(), self.t.heading()))

    def load(self):
        state = self.states.pop()
        self.t.penup()
        self.t.goto(state[0])
        self.t.setheading(state[1])
        self.t.pendown()

    def iterate(self, n):
        for _ in range(n):
            new_sentence = ""
            for char in self.sentence:
                new_sentence += self.rules.get(char, char)
            self.sentence = new_sentence

    def draw(self):
        for char in self.sentence:
            action = self.turtle_rules.get(char)
            if action is not None:
                self.rule_translator[action]()


if __name__ == "__main__":
    ruleset = plant
    L = Lsystem(**ruleset)
