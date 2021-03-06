--  GHDL driver - main part.
--  Copyright (C) 2002, 2003, 2004, 2005 Tristan Gingold
--
--  GHDL is free software; you can redistribute it and/or modify it under
--  the terms of the GNU General Public License as published by the Free
--  Software Foundation; either version 2, or (at your option) any later
--  version.
--
--  GHDL is distributed in the hope that it will be useful, but WITHOUT ANY
--  WARRANTY; without even the implied warranty of MERCHANTABILITY or
--  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
--  for more details.
--
--  You should have received a copy of the GNU General Public License
--  along with GCC; see the file COPYING.  If not, write to the Free
--  Software Foundation, 59 Temple Place - Suite 330, Boston, MA
--  02111-1307, USA.
with GNAT.OS_Lib; use GNAT.OS_Lib;
with Options; use Options;

package Ghdlmain is
   type Command_Type;

   type Command_Acc is access all Command_Type'Class;

   type Command_Type is abstract tagged record
      Next : Command_Acc;
   end record;

   --  Return TRUE iff CMD handle action ACTION.
   function Decode_Command (Cmd : Command_Type; Name : String) return Boolean
     is abstract;

   --  Initialize the command, before decoding actions.
   procedure Init (Cmd : in out Command_Type);

   procedure Decode_Option (Cmd : in out Command_Type;
                            Option : String;
                            Arg : String;
                            Res : out Option_State);

   --  Get a one-line help for the command.
   --  If the first character is '!', the string is not displayed by --help
   --  (for internal commands).
   function Get_Short_Help (Cmd : Command_Type) return String
     is abstract;

   --  Disp detailled help.
   procedure Disp_Long_Help (Cmd : Command_Type);

   --  Perform the action.
   procedure Perform_Action (Cmd : Command_Type; Args : Argument_List)
     is abstract;

   --  Register a command.
   procedure Register_Command (Cmd : Command_Acc);

   --  Disp MSG on the standard output with the command name.
   procedure Error (Msg : String);
   procedure Warning (Msg : String);

   --  Return the index of C in STR, or 0 if not found.
   function Index (Str : String; C : Character) return Natural;

   --  Action failed.
   Compile_Error : exception;

   --  Exec failed: either the program was not found, or failed.
   Exec_Error : exception;

   --  Decode command CMD_NAME and options from ARGS.
   --  Return the index of the first non-option argument.
   procedure Decode_Command_Options (Cmd_Name : String;
                                     Cmd : out Command_Acc;
                                     Args : Argument_List;
                                     First_Arg : out Natural);

   procedure Main;

   --  Additionnal one-line message displayed by the --version command,
   --  if defined.
   --  Used to customize.
   type String_Cst_Acc is access constant String;
   Version_String : String_Cst_Acc := null;

   --  Registers all commands in this package.
   procedure Register_Commands;
end Ghdlmain;
