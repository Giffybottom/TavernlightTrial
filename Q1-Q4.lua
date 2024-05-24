-- Q1-Q4 - Fix or improve the implementation of the below methods.

-- Q1 - Fix or improve the implementation of the below methods

local function releaseStorage(player)
    if player then
        player:setStorageValue(1000, -1)
    end
end

function onLogout(player)
    if player:getStorageValue(1000) == 1 then
        addEvent(releaseStorage, 1000, player)
    end
    return true
end


-- Q2 - Fix or improve the implementation of the below method

function printSmallGuildNames(memberCount)
    -- this method is supposed to print names of all guilds that have less than memberCount max members
    local selectGuildQuery = "SELECT name FROM guilds WHERE max_members < %d;"
    local resultId = db.storeQuery(string.format(selectGuildQuery, memberCount))

    if resultId then
        --Iterate over all rows in the result set
        repeat
            local guildName = result.getString("name")
            print(guildName)
        until no result.next(resultId)

        --Release the result set
        result.free(resultId)
    else
        print("No guilds found with less than " ..members.. " members.")
    end
end


-- Q3 - Fix or improve the name and the implementation of the below method

function removeMemberFromParty(playerId, memberName)
    --Does the player exist?
    local player = Player(playerId)
    if not player then
        print("No Player Found: player = null")
        return
    end
    --Is the player in the party?
    local partyPlayer = player:getParty()
    if not partyPlayer then
        print("Player not found in party: partyPlayer = null")
        return
    end
    --Does the party member exist?
    local partyMember = Player(memberName)
    if not partyMember then  
        print("Member not found in party: partyMember = null")
        return
    end

    local partyMembers = party:getMembers()
    -- key/value used because getMembers return is unkown.
    for _, member in ipairs(partyMembers) do -- Iterate over each pair (N/A, member)
        if member:getName() == memberName then -- Is this the member to remove?
            party:removeMember(v) -- Yes is it.
            print(memberName .. " has been removed from the party.")
            return
        end
    end

    print(memberName .. " is not in the party.") -- Member was not found anywhere.
end

-- // Q4 - Assume all method calls work fine. Fix the memory leak issue in below method

void Game::addItemToPlayer(const std::string& recipient, uint16_t itemId)
{

    Player* player = g_game.getPlayerByName(recipient);

    if (!player) { -- Player was not found
        player = new Player(nullptr); -- A new player is dynamically created
        if (!IOLoginData::loadPlayerByName(player, recipient)) { -- login did not go well
            delete player; 
            return;
        }
    }

    Item* item = Item::CreateItem(itemId);
    if (!item) {
        if(!g_game.getPlayerByName(recipient)) {
            delete player;
        }
        return;
    }

    g_game.internalAddItem(player->getInbox(), item, INDEX_WHEREEVER, FLAG_NOLIMIT);

    if (!g_game.getPlayerByName(recipient) && player->isOffline()) {
        IOLoginData::savePlayer(player);
        delete player;
    }
}
