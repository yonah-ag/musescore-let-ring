/*
 *  MuseScore Plugin: Use Plugin API
 *
 *  Copyright (C) 2022 yonah_ag
 *
 *  This program is free software; you can redistribute it or modify it under
 *  the terms of the GNU General Public License version 3 as published by the
 *  Free Software Foundation and appearing in the accompanying LICENCE file.
 *
 *  Releases
 *  --------
 *  0.0.1 : Alpha 1
 */

import MuseScore 3.0
import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Controls.Styles 1.3
import QtQuick.Layouts 1.1
import QtQuick.Dialogs 1.1

MuseScore
{
   description: "Use Plugin API";
   requiresScore: true;
   version: "0.0.1";
   menuPath: "Plugins.Plugin API";

   property var pXoff: 0.5; // text X-Offset
   property var pYoff: 2.5; // text Y-Offset

   onRun:
   {

      var args = Array.prototype.slice.call(arguments, 1);
      var staveBeg;
      var staveEnd;
      var tickEnd;
      var rewindMode;
      var toEOF;
      var cursor = curScore.newCursor();

      cursor.rewind(Cursor.SELECTION_START);
      if (cursor.segment) {
         staveBeg = cursor.staffIdx;
         cursor.rewind(Cursor.SELECTION_END);
         staveEnd = cursor.staffIdx;
         if (!cursor.tick) {
            toEOF = true;
         }
         else
         {
            toEOF = false;
            tickEnd = cursor.tick;
         }
         rewindMode = Cursor.SELECTION_START;
      }
      else
      {
         staveBeg = 0; // no selection
         staveEnd = curScore.nstaves - 1;
         toEOF = true;
         rewindMode = Cursor.SCORE_START;
      }
      curScore.startCmd();
      for (var stave = staveBeg; stave <= staveEnd; ++stave) {
         cursor.staffIdx = stave;
         cursor.voice = 0;
         cursor.rewind(rewindMode);
         cursor.staffIdx = stave;
         while (cursor.segment && (toEOF || cursor.tick < tickEnd))
         {
            if (cursor.element) {
               if(cursor.element.type == Element.CHORD) {
                  var pitch = cursor.element.notes[0].pitch;
                  var txt = newElement(Element.STAFF_TEXT);
                  txt.text = pitch;
                  txt.placement = Placement.BELOW;
                  txt.offsetX = pXoff;
                  txt.offsetY = pYoff;
                  txt.align = 2; // LEFT = 0, RIGHT = 1, HCENTER = 2, TOP = 0, BOTTOM = 4, VCENTER = 8, BASELINE = 16
				  txt.fontFace = "FreeSans";
                  txt.fontSize = 7;
                  txt.autoplace = true;
                  cursor.add(txt);
               }
            }
            cursor.next();
         }
      }
      curScore.endCmd();
   }
}