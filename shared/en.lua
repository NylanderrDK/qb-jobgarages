local Translations = {
    general = {
        blip = "Job Garage"
    },
    logging = {
        creating_blips = "Creating blips for all garages..",
        opening_menu = "Opening garage menu..",
        spawn_vehicle = "Spawning vehicle..",
        return_vehicle = "Returning vehicle.."
    },
    menu = {
        header = "Job Garage",
        return_vehicle = "Return Vehicle",
        no_vehicles = "No vehicles"
    },
    notifications = {
        received_keys = "You have received the keys to the vehicle!",
        returned_vehicle = "You have returned the vehicle!"
    }
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})