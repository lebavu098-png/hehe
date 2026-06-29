local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

local localPlayer = Players.LocalPlayer

-- Biến cấu hình trạng thái nút bật/tắt chức năng
local HackEnabled = false

-- =============================================================================
-- KHỞI TẠO GIAO DIỆN (UI) - TÊN MENU: LÊ BÁ VŨ
-- =============================================================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "TrollsOpenMenu"
screenGui.ResetOnSpawn = false
screenGui.Parent = localPlayer:WaitForChild("PlayerGui")

-- Khung giao diện chính hiện ngay lập tức
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 240, 0, 150)
mainFrame.Position = UDim2.new(0.4, 0, 0.4, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Visible = true
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 10)
mainCorner.Parent = mainFrame

-- Tiêu đề Menu chính (Đã đổi tên)
local mainTitle = Instance.new("TextLabel")
mainTitle.Size = UDim2.new(1, 0, 0, 40)
mainTitle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
mainTitle.Text = "LÊ BÁ VŨ" -- [ĐÃ ĐỔI TÊN Ở ĐÂY]
mainTitle.TextColor3 = Color3.fromRGB(241, 196, 15) -- Đổi sang màu vàng cho nổi bật tên bạn
mainTitle.TextSize = 18
mainTitle.Font = Enum.Font.SourceSansBold
mainTitle.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent = mainTitle

-- Nút Bật/Tắt chức năng chính
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0.9, 0, 0, 50)
toggleBtn.Position = UDim2.new(0.05, 0, 0.5, -10)
toggleBtn.BackgroundColor3 = Color3.fromRGB(231, 76, 60)
toggleBtn.Text = "CHỨC NĂNG: OFF"
toggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleBtn.TextSize = 16
toggleBtn.Font = Enum.Font.SourceSansBold
toggleBtn.Parent = mainFrame

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 8)
btnCorner.Parent = toggleBtn

toggleBtn.MouseButton1Click:Connect(function()
    HackEnabled = not HackEnabled
    if HackEnabled then
        toggleBtn.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
        toggleBtn.Text = "CHỨC NĂNG: ON"
    else
        toggleBtn.BackgroundColor3 = Color3.fromRGB(231, 76, 60)
        toggleBtn.Text = "CHỨC NĂNG: OFF"
    end
end)

-- =============================================================================
-- LOGIC HACK (CHỈ HOẠT ĐỘNG KHI HACKENABLED = TRUE)
-- =============================================================================

-- Hàm tạo ESP cho người chơi
local function createESP(targetPlayer)if targetPlayer == localPlayer then return end

    local function applyESP()  
        local char = targetPlayer.Character  
        if not char then return end  
          
        local highlight = char:FindFirstChild("ESPHighlight")
        if HackEnabled then
            if not highlight then  
                highlight = Instance.new("Highlight")  
                highlight.Name = "ESPHighlight"  
                highlight.FillColor = Color3.fromRGB(255, 0, 0)  
                highlight.FillTransparency = 0.6  
                highlight.OutlineColor = Color3.fromRGB(255, 255, 255)  
                highlight.OutlineTransparency = 0  
                highlight.Adornee = char  
                highlight.Parent = char  
            end
            highlight.Enabled = true
        else
            if highlight then highlight.Enabled = false end
        end
          
        local head = char:FindFirstChild("Head")  
        if head then
            local billboard = head:FindFirstChild("ESPNameGui")
            if HackEnabled then
                if not billboard then  
                    billboard = Instance.new("BillboardGui")  
                    billboard.Name = "ESPNameGui"  
                    billboard.AlwaysOnTop = true  
                    billboard.Size = UDim2.new(0, 200, 0, 50)  
                    billboard.StudsOffset = Vector3.new(0, 2.5, 0)  
                      
                    local label = Instance.new("TextLabel")  
                    label.Size = UDim2.new(1, 0, 1, 0)  
                    label.BackgroundTransparency = 1  
                    label.Text = targetPlayer.Name  
                    label.TextColor3 = Color3.fromRGB(255, 255, 255)  
                    label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)  
                    label.TextStrokeTransparency = 0  
                    label.TextSize = 14  
                    label.Font = Enum.Font.SourceSansBold  
                    label.Parent = billboard  
                    billboard.Parent = head  
                end
                billboard.Enabled = true
            else
                if billboard then billboard.Enabled = false end
            end
        end  
    end  
      
    RunService.RenderStepped:Connect(applyESP)
end

for _, p in ipairs(Players:GetPlayers()) do createESP(p) end
Players.PlayerAdded:Connect(createESP)

-- Vòng lặp 1: Phóng to Hitbox ẩn (0.99)
RunService.RenderStepped:Connect(function()
    local allPlayers = Players:GetPlayers()
    for i = 1, #allPlayers do
        local targetPlayer = allPlayers[i]

        if targetPlayer ~= localPlayer then  
            local targetCharacter = targetPlayer.Character  
            if targetCharacter then  
                local rootPart = targetCharacter:FindFirstChild("HumanoidRootPart")  
                local humanoid = targetCharacter:FindFirstChildOfClass("Humanoid")  
                  
                if rootPart and humanoid and humanoid.Health > 0 thenif HackEnabled then
                        rootPart.Size = Vector3.new(15, 15, 15)
                        rootPart.Transparency = 0.99 
                    else
                        rootPart.Size = Vector3.new(2, 2, 1)
                        rootPart.Transparency = 0
                    end
                    rootPart.CanCollide = false  
                end  
            end  
        end  
    end
end)

-- Vòng lặp 2: Ép bắn tự động liên tục
task.spawn(function()
    while true do
        task.wait(0.08)

        if HackEnabled then
            local character = localPlayer.Character  
            if character then  
                local blaster = character:FindFirstChild("Blaster") or (localPlayer:FindFirstChildOfClass("Backpack") and localPlayer:FindFirstChildOfClass("Backpack"):FindFirstChild("Blaster"))  
                  
                if blaster then  
                    if blaster.Parent ~= character then blaster.Parent = character end  
                      
                    local shootRemote = ReplicatedStorage:WaitForChild("Blaster"):WaitForChild("Remotes"):WaitForChild("Shoot")  
                    local allPlayers = Players:GetPlayers()  
                    
                    for i = 1, #allPlayers do  
                        local targetPlayer = allPlayers[i]  
                          
                        if targetPlayer ~= localPlayer then
                            local targetCharacter = targetPlayer.Character
                            if targetCharacter then
                                local humanoid = targetCharacter:FindFirstChildOfClass("Humanoid")
                                local rootPart = targetCharacter:FindFirstChild("HumanoidRootPart")
                                
                                if humanoid and humanoid.Health > 0 and rootPart then
                                    local targetPosition = rootPart.Position  
                                    local myPosition = character:GetPivot().Position  
                                    local lookCFrame = CFrame.lookAt(myPosition, targetPosition)  
                                    
                                    local targetContainer = {}
                                    local firstIndex = tostring(1)
                                    targetContainer[firstIndex] = humanoid
                                    
                                    shootRemote:FireServer(Workspace.DistributedGameTime, blaster, lookCFrame, targetContainer)
                                end
                            end
                        end
                    end
                end  
            end
        end
    end
end)
