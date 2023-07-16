unit uUtils;

interface

uses Vcl.Forms, Vcl.StdCtrls, Vcl.ComCtrls, System.SysUtils;

procedure LimparCamposFormulario(const AForm: TForm);

implementation

procedure LimparCamposFormulario(const AForm: TForm);
var i: Integer;
begin
  for i := 0 to AForm.ComponentCount - 1 do
  begin
    if AForm.Components[i] is TEdit then
      TEdit(AForm.Components[i]).Text := ''
    else if AForm.Components[i] is TComboBox then
      TComboBox(AForm.Components[i]).ItemIndex := 0
    else if AForm.Components[i] is TCheckBox then
      TCheckBox(AForm.Components[i]).Checked := False
    else if AForm.Components[i] is TDateTimePicker then
      TDateTimePicker(AForm.Components[i]).DateTime := Now;
  end;
end;


end.
