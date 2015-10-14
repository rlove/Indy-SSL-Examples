//---------------------------------------------------------------------------

#ifndef ExampleFormH
#define ExampleFormH
//---------------------------------------------------------------------------
#include <System.Classes.hpp>
#include <Vcl.Controls.hpp>
#include <Vcl.StdCtrls.hpp>
#include <Vcl.Forms.hpp>
#include <IdAntiFreezeBase.hpp>
#include <IdBaseComponent.hpp>
#include <IdComponent.hpp>
#include <IdContext.hpp>
#include <IdCustomTCPServer.hpp>
#include <IdIOHandler.hpp>
#include <IdIOHandlerSocket.hpp>
#include <IdIOHandlerStack.hpp>
#include <IdServerIOHandler.hpp>
#include <IdSSL.hpp>
#include <IdSSLOpenSSL.hpp>
#include <IdTCPClient.hpp>
#include <IdTCPConnection.hpp>
#include <IdTCPServer.hpp>
#include <Vcl.IdAntiFreeze.hpp>
#include <System.SysUtils.hpp>
//---------------------------------------------------------------------------
class TForm1 : public TForm
{
__published:	// IDE-managed Components
	TLabel *Label1;
	TButton *Button1;
	TMemo *memResults;
	TEdit *edtEcho;
	TButton *Button2;
	TButton *Button3;
	TButton *Button4;
	TButton *Button5;
	TIdTCPServer *IdTCPServer1;
	TIdServerIOHandlerSSLOpenSSL *IdServerIOHandlerSSLOpenSSL1;
	TIdTCPClient *IdTCPClient1;
	TIdSSLIOHandlerSocketOpenSSL *IdSSLIOHandlerSocketOpenSSL1;
	TIdAntiFreeze *IdAntiFreeze1;
	void __fastcall Button1Click(TObject *Sender);
	void __fastcall Button3Click(TObject *Sender);
	void __fastcall Button5Click(TObject *Sender);
	void __fastcall Button4Click(TObject *Sender);
	void __fastcall Button2Click(TObject *Sender);


private:	// User declarations
	void __fastcall TForm1::ServerExecute(TIdContext *AContext);
	void __fastcall TForm1::GetPassword(UnicodeString &Password);
	void __fastcall TForm1::ServerConnect(TIdContext *AContext);
public:		// User declarations
	__fastcall TForm1(TComponent* Owner);
};
//---------------------------------------------------------------------------
extern PACKAGE TForm1 *Form1;
//---------------------------------------------------------------------------
#endif
