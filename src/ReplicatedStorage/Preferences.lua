local module = { 
	["PerformanceWarnings"] = false,       -- Set to true if you want warnings related to minor performance issues (false reduces warning spam while you're not attempting optimization)
	["AllowClientDataChanges"] = true,    -- Toggle this based on the rules you want for data management. Will throw a warning on misuse
	["HandleTag"] = "_Handle",             -- The index that tables use to store their location for networking (If your tables use this index, feel free to change it in ReplicatedStorage.Preferences)
	["DoNotConvertTag"] = "_DoNotConvert", -- Assign this index to a truey value in your table, if you would like it to be converted to a NetSync table (If your tables use this index, feel free to change it in ReplicatedStorage.Preferences)
	["FilterListDefaultTag"] = "_Default", -- Set this index in the FilterList to change the default network behavior of the table
}

return module
