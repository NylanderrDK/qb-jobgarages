Config = {}

Config.Garages = {
    [1] = {
        job = "police", -- Job name (NOT label) which can access this garage
        position = vector4(-463.64, -619.07, 30.57, 90.27), -- Position of the blip/marker and vehicle spawn
        vehicles = {
            [0] = { -- Grade 0
                ["asbo"] = "Asbo", -- Vehicle spawn name first, and then the label
            },
            [1] = { -- Grade 1
                ["rebla"] = "Rebla GTS"
            },
            [2] = { -- Grade 2
                ["t20"] = "Progen T20"
            }
        }
    }
}
