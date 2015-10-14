object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 341
  ClientWidth = 636
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  DesignSize = (
    636
    341)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 296
    Top = 69
    Width = 87
    Height = 13
    Caption = 'Server Responses'
  end
  object Button1: TButton
    Left = 32
    Top = 24
    Width = 201
    Height = 25
    Caption = 'Setup Server and Activate it'
    TabOrder = 0
    OnClick = Button1Click
  end
  object memResults: TMemo
    Left = 296
    Top = 93
    Width = 297
    Height = 227
    Anchors = [akLeft, akTop, akRight, akBottom]
    ReadOnly = True
    TabOrder = 1
  end
  object edtEcho: TEdit
    Left = 296
    Top = 26
    Width = 217
    Height = 21
    TabOrder = 2
    TextHint = 'Enter Echo Text'
  end
  object Button2: TButton
    Left = 519
    Top = 24
    Width = 75
    Height = 25
    Caption = 'Send'
    TabOrder = 3
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 32
    Top = 55
    Width = 201
    Height = 25
    Caption = 'Setup Client and Connect to Server'
    TabOrder = 4
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 32
    Top = 295
    Width = 201
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Close Server'
    TabOrder = 5
    OnClick = Button4Click
  end
  object Button5: TButton
    Left = 32
    Top = 264
    Width = 201
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Quit and Close Client'
    TabOrder = 6
    OnClick = Button5Click
  end
  object IdTCPServer1: TIdTCPServer
    Bindings = <>
    DefaultPort = 0
    Left = 80
    Top = 96
  end
  object IdServerIOHandlerSSLOpenSSL1: TIdServerIOHandlerSSLOpenSSL
    SSLOptions.Mode = sslmUnassigned
    SSLOptions.VerifyMode = []
    SSLOptions.VerifyDepth = 0
    Left = 136
    Top = 112
  end
  object IdTCPClient1: TIdTCPClient
    ConnectTimeout = 0
    IPVersion = Id_IPv4
    Port = 0
    ReadTimeout = -1
    Left = 344
    Top = 224
  end
  object IdSSLIOHandlerSocketOpenSSL1: TIdSSLIOHandlerSocketOpenSSL
    MaxLineAction = maException
    Port = 0
    DefaultPort = 0
    SSLOptions.Mode = sslmUnassigned
    SSLOptions.VerifyMode = []
    SSLOptions.VerifyDepth = 0
    Left = 400
    Top = 248
  end
  object IdAntiFreeze1: TIdAntiFreeze
    Left = 272
    Top = 160
  end
end
