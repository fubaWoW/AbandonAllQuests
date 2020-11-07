local ADDON_NAME, namespace = ...

local frame = CreateFrame("FRAME");
frame:RegisterEvent("ADDON_LOADED");
frame:RegisterEvent("QUEST_LOG_UPDATE");
frame:RegisterEvent("QUEST_FINISHED");
frame:RegisterEvent("QUEST_COMPLETE");

local button = CreateFrame("Button", "AbandonAllQuests_AbandonButton", QuestScrollFrame.DetailFrame, "SharedButtonTemplate");

function AbandonAllQuests_hideButton() 
    button:Hide()
end

function AbandonAllQuests_showButton() 
    button:Show()
end

function frame:OnEvent(event, arg1) 
    if event == "ADDON_LOADED" and arg1 == "AbandonAllQuests" then
        local buttonHeight = 24
        local mapButtonLabel = namespace.AbandonAllQuests_GetTranslation("MAP_BUTTON_LABEL");
        button:SetFrameStrata("DIALOG");
        button:SetWidth(264)
        -- button:SetWidth(strlen(mapButtonLabel) * 8) -- Variable button width based on text length
        button:SetHeight(buttonHeight)
        button:SetText(mapButtonLabel)
        button:SetPoint("BOTTOM",0,1)
        -- button:SetPoint("BOTTOM",0,-buttonHeight/2) -- Vertical position
        button:SetScript("OnClick", AbandonAllQuests_abandonAllQuestsRequest)
        button:Show()

        StaticPopupDialogs["AbandonAllQuests_Request"] = {
            text = namespace.AbandonAllQuests_GetTranslation("ABANDON_DIALOG_QUESTION"),
            button1 = YES,
            button2 = NO,
            OnAccept = AbandonAllQuests_abandonAllQuestsConfirm,
            timeout = 0,
            whileDead = true,
            hideOnEscape = true,
            preferredIndex = 3,
        }

        else if event == "QUEST_LOG_UPDATE" or event == "QUEST_FINISHED" or event == "QUEST_COMPLETE" then 
            local questsAvailable = false;
            for i=1,C_QuestLog.GetNumQuestLogEntries() do 
                local questInfo = C_QuestLog.GetInfo(i);
                if (not questInfo.isHeader and not questInfo.isHidden) then
                    questsAvailable = true;
                    break;
                end
            end

            if questsAvailable then 
                AbandonAllQuests_showButton() 
            else 
                AbandonAllQuests_hideButton()
            end
        end
    end

end
frame:SetScript("OnEvent", frame.OnEvent);

function AbandonAllQuests_abandonAllQuestsConfirm()
    for i=1,C_QuestLog.GetNumQuestLogEntries() do 
        local questInfo = C_QuestLog.GetInfo(i);
        if (not questInfo.isHeader and not questInfo.isHidden) then
            DEFAULT_CHAT_FRAME:AddMessage(format(namespace.AbandonAllQuests_GetTranslation("ABANDON_QUEST_SUCCESS"), questInfo.title), 1.0, 1.0, 0.0);
            C_QuestLog.SetSelectedQuest(questInfo.questID); 
            C_QuestLog.SetAbandonQuest(); 
            C_QuestLog.AbandonQuest()    
        end
    end
end

function AbandonAllQuests_abandonAllQuestsRequest()
    StaticPopup_Show("AbandonAllQuests_Request")
end
