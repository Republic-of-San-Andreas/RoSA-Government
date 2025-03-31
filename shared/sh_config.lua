Config = Config or {}

Config.Settings = {
    ['Gender'] = {
        ['Male'] = "Mr.",
        ['Female'] = "Mrs.",
    },
    ['Timer'] = 2000,
    ['AllowedJobs'] = {
        -- ['name-in-core'] = { -- Must match the name as specified in qb/shared/job.lua
        --     ['Label'] = "", -- Can be any form of string
        --     ['LogoLink'] = "", -- Should end in .png preferabbly.
        -- },
        ['doj'] = {
            ['Label'] = "Department of Justice",
            ['LogoLink'] = "https://r2.fivemanage.com/1agQtY1XGRHK81qkmLTpG/images/SA.png",
        },
        ['trooper'] = {
            ['Label'] = "San Andreas State Troopers",
            ['LogoLink'] = "https://r2.fivemanage.com/06qZ80CuPMc06ak81BqvS/Logo.png",
        },
        ['police'] = {
            ['Label'] = "Los Santos Police Department",
            ['LogoLink'] = "https://r2.fivemanage.com/1agQtY1XGRHK81qkmLTpG/image/lspd_main.png",
        },
        ['sheriff'] = {
            ['Label'] = "Los Santos County Sheriff's Office",
            ['LogoLink'] = "https://r2.fivemanage.com/06qZ80CuPMc06ak81BqvS/BCSO.png",
        },
        ['firedept'] = {
            ['Label'] = "San Andreas Fire Department",
            ['LogoLink'] = "https://r2.fivemanage.com/1agQtY1XGRHK81qkmLTpG/image/SAFRRemake.png",
        },
        ['saems'] = {
            ['Label'] = "San Andreas - Emergency Medical Services",
            ['LogoLink'] = "https://r2.fivemanage.com/1agQtY1XGRHK81qkmLTpG/image/saems.png",
        }
    },
}