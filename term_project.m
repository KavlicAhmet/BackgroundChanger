main
function main()
    fig = figure('Name', 'Matlab GUI', 'Position', [800, 500, 300, 200]);

    % İlk Push Button
    btn1 = uicontrol('Style', 'pushbutton', 'String', ['Change Backround Color'], 'Position', [50, 120, 200, 30], 'Callback', @btn1BtnCallback);
    
    % İkinci Push Button
    btn2 = uicontrol('Style', 'pushbutton', 'String', ['Similar In Color'], 'Position', [50, 60, 200, 30], 'Callback', @btn2BtnCallback);
    
    
    function btn1BtnCallback(~, ~)
        clc;
        close all;
        clear;
        myGUI
    end
    function btn2BtnCallback(~, ~)
        clc;
        close all;
        clear;
        yourGUI
    end
end



function myGUI()
    newBackgroundColor = [255, 255, 255];
    oldBackgroundColor = [255, 255, 255];
    tolerance = 30;
    isSave = 0;
    % GUI penceresini oluştur
    fig = figure('Name', 'Matlab GUI', 'Position', [500, 300, 700, 500]);
    backBtn = uicontrol('Style', 'pushbutton', 'String', ['<Back'], 'Position', [10, 470, 45, 25], 'Callback', @backBtnCallback);
    prevRedBtn = uicontrol('Style', 'pushbutton', 'String', ['Red'], 'Position', [10, 425, 50, 25], 'Callback', @prevRedBtnCallback);
    prevGreenBtn = uicontrol('Style', 'pushbutton', 'String', ['Green'], 'Position', [60, 425, 50, 25], 'Callback', @prevGreenBtnCallback);
    prevBlueBtn = uicontrol('Style', 'pushbutton', 'String', ['Blue'], 'Position', [110, 425, 50, 25], 'Callback', @prevBlueBtnCallback);
    prevWhiteBtn = uicontrol('Style', 'pushbutton', 'String', ['White'], 'Position', [160, 425, 50, 25], 'Callback', @prevWhiteBtnCallback);
    prevBlackBtn = uicontrol('Style', 'pushbutton', 'String', ['Black'], 'Position', [210, 425, 50, 25], 'Callback', @prevBlackBtnCallback);
   
    % Resim seçme düğmesini oluştur
    selectImageBtn = uicontrol('Style', 'pushbutton', 'String', 'Select Image', 'Position', [80, 200, 80, 25], 'Callback', @selectImageCallback);

    % Resim gösterme eksenini oluştur
    prevImage = axes('Parent', fig, 'Position', [0.05, 0.5, 0.25, 0.25]);
    lastImage = axes('Parent', fig, 'Position', [0.4, 0.3, 0.55, 0.6]);

    redBtn = uicontrol('Style', 'pushbutton', 'String', ['Red'], 'Position', [320, 100, 70, 30], 'Callback', @redBtnCallback);
    greenBtn = uicontrol('Style', 'pushbutton', 'String', ['Green'], 'Position', [400, 100, 70, 30], 'Callback', @greenBtnCallback);
    blueBtn = uicontrol('Style', 'pushbutton', 'String', ['Blue'], 'Position', [480, 100, 70, 30], 'Callback', @blueBtnCallback);
    orangeBtn = uicontrol('Style', 'pushbutton', 'String', ['Orange'], 'Position', [560, 100, 70, 30], 'Callback', @orangeBtnCallback);
    yellowBtn = uicontrol('Style', 'pushbutton', 'String', ['Yellow'], 'Position', [320, 50, 70, 30], 'Callback', @yellowBtnCallback);
    whiteBtn = uicontrol('Style', 'pushbutton', 'String', ['White'], 'Position', [400, 50, 70, 30], 'Callback', @whiteBtnCallback);
    blackBtn = uicontrol('Style', 'pushbutton', 'String', ['Black'], 'Position', [480, 50, 70, 30], 'Callback', @blackBtnCallback);
    xxBtn = uicontrol('Style', 'pushbutton', 'String', ['Save'], 'Position', [560, 50, 70, 30], 'Callback', @pushButtonCallback);
    
    % Seçilen resmin yolu
    selectedImagePath = '';

    % Resim seçme işlevi
    function selectImageCallback(~, ~)
        [filename, pathname] = uigetfile({'*.png;*.jpg;*.jpeg', 'Resim Dosyaları (*.png, *.jpg, *.jpeg)'}, 'Resim Seç');
        if filename ~= 0
            selectedImagePath = fullfile(pathname, filename);
            showSelectedImage();
        end
    end

    % Seçilen resmi gösterme işlevi
    function showSelectedImage()
        if exist(selectedImagePath, 'file')
            img = imread(selectedImagePath);
            imshow(img, 'Parent', prevImage);
        end
    end
    
    function process()
        originalImage = imread(selectedImagePath);
        [rows, cols, ~] = size(originalImage);
    
        % Renk farkını hesapla
        colorDifference = zeros(rows, cols);
        
        for i = 1:3
            colorDifference = colorDifference + (double(originalImage(:, :, i)) - oldBackgroundColor(i)).^2;
        end
        
        colorDifference = sqrt(colorDifference);
        
        % Renk farkının tolerans içinde olduğu pikselleri bul
        backgroundPixels = colorDifference < tolerance;
        
        % Yeni arkaplan rengindeki pikselleri bul
        newBackgroundPixels = bsxfun(@times, backgroundPixels, permute(newBackgroundColor, [1, 3, 2]));
        
        % Yeni arkaplan piksellerini orijinal resme ekle
        newImage = originalImage;
        
        % Yeni arkaplan piksellerini genişlet
        expandedBackgroundPixels = repmat(backgroundPixels, [1, 1, 3]);
        
        % Yeni resmi güncelle
        newImage(expandedBackgroundPixels) = newBackgroundPixels(expandedBackgroundPixels);
        imshow(newImage, 'Parent', lastImage);
        if isSave == 1
            [filename, pathname] = uiputfile({'*.jpg;*.png', 'Desteklenen Formatlar (*.jpg, *.png)'}, 'Resmi Kaydet');

            % Kullanıcı kaydetmeyi iptal ettiyse uiputfile sonucu 0 olacaktır
            if isequal(filename, 0) || isequal(pathname, 0)
                msgbox('The save operation has been cancelled.', 'Result', 'modal');
            else
                % Tam dosya yolunu oluşturun
                fullFilePath = fullfile(pathname, filename);
            
                % Resmi kaydedin
                imwrite(newImage, fullFilePath);
            
                
                msgbox('Image saved successfully!', 'Saved Result', 'modal');
            end
            isSave = 0;
        end
    end
    function backBtnCallback(~, ~)
        clc;
        close all;
        clear;
        main
    end
    function prevRedBtnCallback(~, ~)
        oldBackgroundColor = [255, 0, 0];
    end
    function prevGreenBtnCallback(~, ~)
        oldBackgroundColor = [0, 255, 0];
    end
    function prevBlueBtnCallback(~, ~)
        oldBackgroundColor = [0, 0, 255];
    end
    function prevWhiteBtnCallback(~, ~)
        oldBackgroundColor = [255, 255, 255];
    end
    function prevBlackBtnCallback(~, ~)
        oldBackgroundColor = [0, 0, 0];
    end
    % Push düğme işlevi
    function redBtnCallback(~, ~)
        newBackgroundColor = [255, 0, 0];
        process();
    end
    function greenBtnCallback(~, ~)
        newBackgroundColor = [0, 255, 0];
        process();
    end
    function blueBtnCallback(~, ~)
        newBackgroundColor = [0, 0, 255];
        process();
    end
    function whiteBtnCallback(~, ~)
        newBackgroundColor = [255, 255, 255];
        process();
    end
    function orangeBtnCallback(~, ~)
        newBackgroundColor = [255, 165, 0];
        process();
    end
    function yellowBtnCallback(~, ~)
        newBackgroundColor = [255, 255, 0];
        process();
    end
    function blackBtnCallback(~, ~)
        newBackgroundColor = [0, 0, 0];
        process();
    end
    function pushButtonCallback(~, ~)
        isSave = 1;
        process();
    end

end

function yourGUI()
    fig = figure('Name', 'Matlab GUI', 'Position', [500, 300, 700, 500]);
    handles.firstImage = axes('Parent', fig, 'Position', [0.05, 0.5, 0.40, 0.40]);
    handles.secondImage = axes('Parent', fig, 'Position', [0.55, 0.5, 0.40, 0.40]);
    handles.selectfirstImageBtn = uicontrol('Style', 'pushbutton', 'String', 'Select Image', 'Position', [130, 175, 80, 25], 'Callback', @firstselectImageCallback);
    handles.selectsecondImageBtn = uicontrol('Style', 'pushbutton', 'String', 'Select Image', 'Position', [480, 175, 80, 25], 'Callback', @secondselectImageCallback);
    handles.startBtn = uicontrol('Style', 'pushbutton', 'String', 'Process', 'Position', [305, 100, 80, 25], 'Callback', @startCallback);
    backBtn = uicontrol('Style', 'pushbutton', 'String', ['<Back'], 'Position', [10, 470, 45, 25], 'Callback', @backBtnCallback);
        % handles yapısını güncelle
    guidata(fig, handles);   
    
    function startCallback(~, ~)
        handles = guidata(gcf); % handles yapısını al
        process(handles);
    end
    
    function process(handles)
        selectedImagePath1 = handles.selectedImagePath1;
        selectedImagePath2 = handles.selectedImagePath2;
        
        image1 = imread(selectedImagePath1);
        image2 = imread(selectedImagePath2);
        [image1, image2] = resizeImages(image1, image2);
    
        similarity = calculateColorSimilarity(image1, image2);
    
        if similarity > 0.6
            resultMessage = 'The flowers are similar. Matching flower found.';
        else
            resultMessage = 'The flowers are not similar. No matching flowers found.';
        end
        
        % Display the result in a message box
        msgbox(resultMessage, 'Similarity Result', 'modal');
    
       
    end
    
    function firstselectImageCallback(~, ~)
        handles = guidata(gcf); % handles yapısını al
        [filename, pathname] = uigetfile({'*.png;*.jpg;*.jpeg', 'Resim Dosyaları (*.png, *.jpg, *.jpeg)'}, 'Resim Seç');
        if filename ~= 0
            handles.selectedImagePath1 = fullfile(pathname, filename);
            image1 = imread(handles.selectedImagePath1);
            imshow(image1, 'Parent', handles.firstImage);
            guidata(gcf, handles); % handles yapısını güncelle
        end
    end
    function backBtnCallback(~, ~)
        clc;
        close all;
        clear;
        main
    end
    function secondselectImageCallback(~, ~)
        handles = guidata(gcf); % handles yapısını al
        [filename, pathname] = uigetfile({'*.png;*.jpg;*.jpeg', 'Resim Dosyaları (*.png, *.jpg, *.jpeg)'}, 'Resim Seç');
        if filename ~= 0
            handles.selectedImagePath2 = fullfile(pathname, filename);
            image2 = imread(handles.selectedImagePath2);
            imshow(image2, 'Parent', handles.secondImage);
            guidata(gcf, handles); % handles yapısını güncelle
        end
    end
    
    function [image1, image2] = resizeImages(image1, image2)
        desiredSize = [256, 256];
        image1 = imresize(image1, desiredSize);
        image2 = imresize(image2, desiredSize);
    end
    
    function similarity = calculateColorSimilarity(image1, image2)
        colorSpace = 'RGB';
        image1 = convertColorSpace(image1, colorSpace);
        image2 = convertColorSpace(image2, colorSpace);
        similarity = ssim(image1, image2);
    end
    
    function image = convertColorSpace(image, colorSpace)
        if strcmpi(colorSpace, 'RGB')
            % Zaten RGB renk uzayında olduğundan bir şey yapma
        elseif strcmpi(colorSpace, 'Lab')
            image = rgb2lab(image);
        else
            error('Invalid color space selection!');
        end
    end
end
