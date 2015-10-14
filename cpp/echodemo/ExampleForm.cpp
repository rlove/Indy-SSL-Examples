//---------------------------------------------------------------------------

#include <vcl.h>
#pragma hdrstop

#include "ExampleForm.h"
//---------------------------------------------------------------------------
#pragma package(smart_init)
#pragma resource "*.dfm"
TForm1 *Form1;
const int SERVER_PORT = 6050;
//---------------------------------------------------------------------------
void __fastcall TForm1::ServerExecute(TIdContext *AContext)
{
  AContext->Connection->IOHandler->WriteLn("Welcome to the Echo Server");
  bool Connected = true;
  while (Connected)
  {
	UnicodeString lCmdLine = AContext->Connection->IOHandler->ReadLn();
	AContext->Connection->IOHandler->WriteLn(">" + lCmdLine);

	if (SameText(lCmdLine,"QUIT"))
	{
	  AContext->Connection->IOHandler->WriteLn("Disconnecting");
	  AContext->Connection->Disconnect();
	  Connected = false;
	}
  }
}

void __fastcall TForm1::ServerConnect(TIdContext *AContext)
{
  //These lines are required to get SSL to work.
  TIdSSLIOHandlerSocketBase* socket =
	  dynamic_cast<TIdSSLIOHandlerSocketBase*>(AContext->Connection->IOHandler);

  if (socket)
	socket->PassThrough = false;
}

void __fastcall TForm1::GetPassword(UnicodeString &Password)
{
 //In the real world:
 //   This should never be hardcoded as it could change when the cert changes.
 //   Don't use Dictonary Words or your key can be brute force attacked.
 Password = "test";
}


//---------------------------------------------------------------------------
__fastcall TForm1::TForm1(TComponent* Owner)
	: TForm(Owner)
{
}
//---------------------------------------------------------------------------
void __fastcall TForm1::Button1Click(TObject *Sender)
{
 //In the real world:
 //    FileNames should not be hardcoded, let the be configured external.
 //    Certs expire and change be prepared to handle it.
  IdServerIOHandlerSSLOpenSSL1->SSLOptions->CertFile = "c:\\dev\\keys\\localhost.cert.pem";
  IdServerIOHandlerSSLOpenSSL1->SSLOptions->KeyFile = "c:\\dev\\keys\\localhost.key.pem";
  IdServerIOHandlerSSLOpenSSL1->SSLOptions->RootCertFile = "C:\\dev\\keys\\ca.cert.pem";
  IdServerIOHandlerSSLOpenSSL1->SSLOptions->Mode = sslmServer;
  IdServerIOHandlerSSLOpenSSL1->SSLOptions->VerifyMode = TIdSSLVerifyModeSet();
  IdServerIOHandlerSSLOpenSSL1->SSLOptions->VerifyDepth  = 0;
  IdServerIOHandlerSSLOpenSSL1->SSLOptions->SSLVersions = TIdSSLVersions() << sslvTLSv1_2;
  IdServerIOHandlerSSLOpenSSL1->OnGetPassword = GetPassword;


  IdTCPServer1->DefaultPort = SERVER_PORT;
  IdTCPServer1->IOHandler = IdServerIOHandlerSSLOpenSSL1;
  IdTCPServer1->OnConnect = ServerConnect;


  IdTCPServer1->OnExecute = ServerExecute;
  IdTCPServer1->Active = True;
}

//---------------------------------------------------------------------------



void __fastcall TForm1::Button3Click(TObject *Sender)
{
 // Ok for self singned but you will want to verify if you are using signed certs
  IdSSLIOHandlerSocketOpenSSL1->SSLOptions->VerifyMode = TIdSSLVerifyModeSet();
  IdSSLIOHandlerSocketOpenSSL1->SSLOptions->VerifyDepth = 0;

  IdSSLIOHandlerSocketOpenSSL1->SSLOptions->SSLVersions = TIdSSLVersions();
  IdSSLIOHandlerSocketOpenSSL1->SSLOptions->SSLVersions =
	 IdSSLIOHandlerSocketOpenSSL1->SSLOptions->SSLVersions << sslvTLSv1_2;
  IdSSLIOHandlerSocketOpenSSL1->SSLOptions->Mode = sslmUnassigned;

  IdTCPClient1->Host = "127.0.0.1";
  IdTCPClient1->Port = SERVER_PORT;
  IdTCPClient1->ReadTimeout = 50;
  IdTCPClient1->IOHandler = IdSSLIOHandlerSocketOpenSSL1;

  IdTCPClient1->Connect();

  memResults->Lines->Add(IdTCPClient1->IOHandler->ReadLn());

}
//---------------------------------------------------------------------------

void __fastcall TForm1::Button5Click(TObject *Sender)
{
  IdTCPClient1->SendCmd("QUIT");
  IdTCPClient1->Disconnect();
}
//---------------------------------------------------------------------------

void __fastcall TForm1::Button4Click(TObject *Sender)
{
  IdTCPServer1->Active = false;
}
//---------------------------------------------------------------------------



void __fastcall TForm1::Button2Click(TObject *Sender)
{
  IdTCPClient1->IOHandler->WriteLn(edtEcho->Text);
  memResults->Lines->Add(IdTCPClient1->IOHandler->ReadLn());

}
//---------------------------------------------------------------------------

