-- Criar GUI principal
local ScreenGui = Instance.new("ScreenGui", game.CoreGui)
ScreenGui.Name = "BloxFruitsSuperScript"

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0, 350, 0, 400)
Frame.Position = UDim2.new(0.05, 0, 0.2, 0)
Frame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
Frame.Active = true
Frame.Draggable = true

-- Criar abas
local Tabs = Instance.new("Frame", Frame)
Tabs.Size = UDim2.new(0, 100, 1, 0)
Tabs.Position = UDim2.new(0, 0, 0, 0)
Tabs.BackgroundColor3 = Color3.fromRGB(30,30,30)

local Pages = Instance.new("Frame", Frame)
Pages.Size = UDim2.new(1, -100, 1, 0)
Pages.Position = UDim2.new(0, 100, 0, 0)
Pages.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

-- Função para criar botão de aba
local function CreateTabButton(text, yPos)
    local btn = Instance.new("TextButton", Tabs)
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.Position = UDim2.new(0, 0, 0, yPos)
    btn.Text = text
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.AutoButtonColor = false
    return btn
end

-- Criar botões das abas
local btnFarm = CreateTabButton("Auto Farm", 0)
local btnUpStats = CreateTabButton("Up Stats", 40)
local btnShop = CreateTabButton("Loja Frutas", 80)
local btnHaki = CreateTabButton("Comprar Hakis", 120)

-- Criar páginas (frames) para cada aba
local pageFarm = Instance.new("Frame", Pages)
pageFarm.Size = UDim2.new(1,0,1,0)
pageFarm.BackgroundTransparency = 1
pageFarm.Visible = true

local pageUpStats = Instance.new("Frame", Pages)
pageUpStats.Size = UDim2.new(1,0,1,0)
pageUpStats.BackgroundTransparency = 1
pageUpStats.Visible = false

local pageShop = Instance.new("Frame", Pages)
pageShop.Size = UDim2.new(1,0,1,0)
pageShop.BackgroundTransparency = 1
pageShop.Visible = false

local pageHaki = Instance.new("Frame", Pages)
pageHaki.Size = UDim2.new(1,0,1,0)
pageHaki.BackgroundTransparency = 1
pageHaki.Visible = false

-- Função para alternar abas
local function SwitchTab(page)
    pageFarm.Visible = false
    pageUpStats.Visible = false
    pageShop.Visible = false
    pageHaki.Visible = false
    page.Visible = true
end

btnFarm.MouseButton1Click:Connect(function() SwitchTab(pageFarm) end)
btnUpStats.MouseButton1Click:Connect(function() SwitchTab(pageUpStats) end)
btnShop.MouseButton1Click:Connect(function() SwitchTab(pageShop) end)
btnHaki.MouseButton1Click:Connect(function() SwitchTab(pageHaki) end)

-- ================== Conteúdo da aba Auto Farm ==================
local farmToggle = Instance.new("TextButton", pageFarm)
farmToggle.Text = "Ativar Auto Farm"
farmToggle.Size = UDim2.new(0, 200, 0, 50)
farmToggle.Position = UDim2.new(0.1, 0, 0.1, 0)

local farming = false
farmToggle.MouseButton1Click:Connect(function()
    farming = not farming
    if farming then
        farmToggle.Text = "Desativar Auto Farm"
        spawn(function()
            while farming do
                wait(1)
                -- Código simplificado do auto farm (exemplo)
                pcall(function()
                    local enemies = workspace.Enemies:GetChildren()
                    for _, mob in pairs(enemies) do
                        if mob:FindFirstChild("HumanoidRootPart") and mob.Humanoid.Health > 0 then
                            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0,10,0)
                            -- Atacar exemplo
                            game:GetService("VirtualInputManager"):SendKeyEvent(true, "E", false, game)
                            game:GetService("VirtualInputManager"):SendKeyEvent(false, "E", false, game)
                            wait(0.3)
                        end
                    end
                end)
            end
        end)
    else
        farmToggle.Text = "Ativar Auto Farm"
    end
end)

-- ================== Conteúdo da aba Up Stats ==================
local stats = {"Melee", "Defense", "Sword", "Gun", "Devil Fruit"}

local upStatsToggles = {}

local toggleUpStatsBtn = Instance.new("TextButton", pageUpStats)
toggleUpStatsBtn.Text = "Iniciar Up Stats"
toggleUpStatsBtn.Size = UDim2.new(0, 200, 0, 50)
toggleUpStatsBtn.Position = UDim2.new(0.1, 0, 0.1, 0)

for i, stat in ipairs(stats) do
    local cb = Instance.new("TextButton", pageUpStats)
    cb.Text = "Upar "..stat
    cb.Size = UDim2.new(0, 100, 0, 40)
    cb.Position = UDim2.new(0.1, 0, 0.2 + 0.1*i, 0)
    upStatsToggles[stat] = false
    cb.MouseButton1Click:Connect(function()
        upStatsToggles[stat] = not upStatsToggles[stat]
        cb.BackgroundColor3 = upStatsToggles[stat] and Color3.fromRGB(0,255,0) or Color3.fromRGB(150,150,150)
    end)
end

local upStatsActive = false
toggleUpStatsBtn.MouseButton1Click:Connect(function()
    upStatsActive = not upStatsActive
    toggleUpStatsBtn.Text = upStatsActive and "Parar Up Stats" or "Iniciar Up Stats"
    spawn(function()
        while upStatsActive do
            wait(1)
            for statName, enabled in pairs(upStatsToggles) do
                if enabled then
                    pcall(function()
                        game:GetService("ReplicatedStorage").Remotes.LevelUpStat:InvokeServer(statName)
                    end)
                end
            end
        end
    end)
end)

-- ================== Conteúdo da aba Loja de Frutas ==================
local fruitList = Instance.new("ScrollingFrame", pageShop)
fruitList.Size = UDim2.new(0.9, 0, 0.8, 0)
fruitList.Position = UDim2.new(0.05, 0, 0.15, 0)
fruitList.CanvasSize = UDim2.new(0, 0, 0, 0)

local function updateFruitList()
    fruitList:ClearAllChildren()
    local shopFolder = workspace:FindFirstChild("FruitShop") or workspace:FindFirstChild("Shop") -- Exemplo
    local y = 0
    if shopFolder then
        for _, fruit in pairs(shopFolder:GetChildren()) do
            if fruit:IsA("Tool") then
                local btn = Instance.new("TextButton", fruitList)
                btn.Text = fruit.Name
                btn.Size = UDim2.new(1, 0, 0, 40)
                btn.Position = UDim2.new(0, 0, 0, y)
                y = y + 45
                btn.MouseButton1Click:Connect(function()
                    -- Comprar fruta
                    pcall(function()
                        game:GetService("ReplicatedStorage").Remotes.BuyFruit:InvokeServer(fruit.Name)
                    end)
                end)
            end
        end
        fruitList.CanvasSize = UDim2.new(0, 0, 0, y)
    end
end

updateFruitList()

-- ================== Conteúdo da aba Comprar Hakis ==================
local hakiList = {"Buso", "Geppo", "Soru", "Tekkai", "Sharkman Karat", "Electro"}

local hakiLabel = Instance.new("TextLabel", pageHaki)
hakiLabel.Text = "Clique para comprar todos os hakis"
hakiLabel.Size = UDim2.new(0.8, 0, 0, 40)
hakiLabel.Position = UDim2.new(0.1, 0, 0.1, 0)
hakiLabel.TextColor3 = Color3.new(1,1,1)

local buyAllBtn = Instance.new("TextButton", pageHaki)
buyAllBtn.Text = "Comprar Todos"
buyAllBtn.Size = UDim2.new(0.8, 0, 0, 50)
buyAllBtn.Position = UDim2.new(0.1, 0, 0.3, 0)

buyAllBtn.MouseButton1Click:Connect(function()
    for _, hakiName in pairs(hakiList) do
        pcall(function()
            game:GetService("ReplicatedStorage").Remotes.CommF_:InvokeServer("Buso", hakiName)
        end)
    end
end)
