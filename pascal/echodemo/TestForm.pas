unit TestForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, IdServerIOHandler, IdSSL, IdSSLOpenSSL,
  IdBaseComponent, IdComponent, IdCustomTCPServer, IdTCPServer, IdContext, Vcl.StdCtrls,
  IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack, IdTCPConnection, IdTCPClient,
  IdAntiFreezeBase, Vcl.IdAntiFreeze;

type
  TForm2 = class(TForm)
    Button1: TButton;
    IdTCPServer1: TIdTCPServer;
    IdServerIOHandlerSSLOpenSSL1: TIdServerIOHandlerSSLOpenSSL;
    memResults: TMemo;
    Button2: TButton;
    IdTCPClient1: TIdTCPClient;
    IdSSLIOHandlerSocketOpenSSL1: TIdSSLIOHandlerSocketOpenSSL;
    Button3: TButton;
    edtEcho: TEdit;
    Button4: TButton;
    Button5: TButton;
    Label1: TLabel;
    IdAntiFreeze1: TIdAntiFreeze;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure IdTCPServer1Connect(AContext: TIdContext);
    procedure IdSSLIOHandlerSocketOpenSSL1Status(ASender: TObject;
      const AStatus: TIdStatus; const AStatusText: string);

  private
    { Private declarations }
    procedure ServerExecute(AContext: TIdContext);
    procedure GetPassword(var Password: string);
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation
const
  SERVER_PORT = 6050;

{$R *.dfm}

procedure TForm2.Button1Click(Sender: TObject);
begin
 //In the real world:
 //    FileNames should not be hardcoded, let the be configured external.
 //    Certs expire and change be prepared to handle it.
  IdServerIOHandlerSSLOpenSSL1.SSLOptions.CertFile := 'c:\dev\keys\localhost.cert.pem';
  IdServerIOHandlerSSLOpenSSL1.SSLOptions.KeyFile := 'c:\dev\keys\localhost.key.pem';
  IdServerIOHandlerSSLOpenSSL1.SSLOptions.RootCertFile := 'C:\dev\keys\ca.cert.pem';
  IdServerIOHandlerSSLOpenSSL1.SSLOptions.Mode := sslmServer;
  IdServerIOHandlerSSLOpenSSL1.SSLOptions.VerifyMode := [];
  IdServerIOHandlerSSLOpenSSL1.SSLOptions.VerifyDepth  := 0;
  IdServerIOHandlerSSLOpenSSL1.SSLOptions.SSLVersions := [sslvTLSv1_2];    // Avoid using SSL
  IdServerIOHandlerSSLOpenSSL1.OnGetPassword := GetPassword;


  IdTCPServer1.DefaultPort := SERVER_PORT;
  IdTCPServer1.IOHandler := IdServerIOHandlerSSLOpenSSL1;

  IdTCPServer1.OnExecute := ServerExecute;
  IdTCPServer1.Active := True;

end;

procedure TForm2.Button2Click(Sender: TObject);
begin
  IdTCPClient1.IOHandler.WriteLn(edtEcho.text);
  memResults.Lines.add(IdTCPClient1.IOHandler.Readln());
end;

procedure TForm2.Button3Click(Sender: TObject);
begin
 // Ok for self singned but you will want to verify if you are using signed certs
  IdSSLIOHandlerSocketOpenSSL1.sslOptions.VerifyMode := [];
  IdSSLIOHandlerSocketOpenSSL1.sslOptions.VerifyDepth := 0;

  IdSSLIOHandlerSocketOpenSSL1.sslOptions.SSLVersions := [sslvTLSv1_2];
  IdSSLIOHandlerSocketOpenSSL1.sslOptions.Mode := sslmUnassigned;

  IdTCPClient1.Host := '127.0.0.1';
  IdTCPClient1.Port := SERVER_PORT;
  IdTCPClient1.ReadTimeout := 50;
  IdTCPClient1.IOHandler := IdSSLIOHandlerSocketOpenSSL1;

  IdTCPClient1.Connect;

  memResults.Lines.add(IdTCPClient1.IOHandler.ReadLn);

end;

procedure TForm2.Button4Click(Sender: TObject);
begin
  IdTCPServer1.Active := false;
end;

procedure TForm2.Button5Click(Sender: TObject);
begin
  IdTCPClient1.SendCmd('QUIT');
  IdTCPClient1.Disconnect;
end;

procedure TForm2.GetPassword(var Password: string);
begin
 //In the real world:
 //   This should never be hardcoded as it could change when the cert changes.
 //   Don't use Dictonary Words or your key can be brute force attacked.
 Password := 'test';
end;

procedure TForm2.IdSSLIOHandlerSocketOpenSSL1Status(ASender: TObject;
  const AStatus: TIdStatus; const AStatusText: string);
begin
   memResults.Lines.Add(AStatusText);
end;

procedure TForm2.IdTCPServer1Connect(AContext: TIdContext);
begin
  //These two lines are required to get SSL to work.
  if (AContext.Connection.IOHandler is TIdSSLIOHandlerSocketBase) then
      TIdSSLIOHandlerSocketBase(AContext.Connection.IOHandler).PassThrough := false;

end;

procedure TForm2.ServerExecute(AContext: TIdContext);
var
  lCmdLine: string;
  connected : Boolean;
begin
  AContext.Connection.IOHandler.WriteLn('Welcome to the Echo Server');
  Connected := true;
  while Connected do
  begin
    lCmdLine := AContext.Connection.IOHandler.ReadLn;
    AContext.Connection.IOHandler.Writeln('>' + lCmdLine);

    if SameText(lCmdLine, 'QUIT') then
    begin

      AContext.Connection.IOHandler.Writeln('Disconnecting');
      AContext.Connection.Disconnect;
      Connected := false;
    end;
  end;
end;


end.
