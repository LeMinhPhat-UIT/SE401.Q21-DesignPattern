using System;
using System.Collections.Generic;

public class EditorMemento
{
    private readonly string _content;
    private readonly int _cursorPosition;
    private readonly DateTime _savedAt;

    public EditorMemento(string content, int cursorPosition)
    {
        _content = content;
        _cursorPosition = cursorPosition;
        _savedAt = DateTime.Now;
    }

    public string GetContent()
    {
        return _content;
    }

    public int GetCursorPosition()
    {
        return _cursorPosition;
    }

    public string GetLabel()
    {
        return $"Saved at {_savedAt:HH:mm:ss}, length = {_content.Length}";
    }
}

public class TextEditor
{
    private string _content = "";
    private int _cursorPosition = 0;

    public void Type(string text)
    {
        _content = _content.Insert(_cursorPosition, text);
        _cursorPosition += text.Length;
    }

    public void MoveCursor(int position)
    {
        if (position < 0 || position > _content.Length)
        {
            throw new ArgumentOutOfRangeException(nameof(position));
        }

        _cursorPosition = position;
    }

    public EditorMemento CreateSnapshot()
    {
        return new EditorMemento(_content, _cursorPosition);
    }

    public void Restore(EditorMemento memento)
    {
        _content = memento.GetContent();
        _cursorPosition = memento.GetCursorPosition();
    }

    public void Show()
    {
        Console.WriteLine($"Content: '{_content}' | Cursor: {_cursorPosition}");
    }
}

public class EditorHistory
{
    private readonly Stack<EditorMemento> _undoStack = new();

    public void Save(TextEditor editor)
    {
        _undoStack.Push(editor.CreateSnapshot());
    }

    public void Undo(TextEditor editor)
    {
        if (_undoStack.Count == 0)
        {
            Console.WriteLine("Nothing to undo.");
            return;
        }

        EditorMemento snapshot = _undoStack.Pop();
        editor.Restore(snapshot);
        Console.WriteLine($"Restored: {snapshot.GetLabel()}");
    }
}

public class Program
{
    public static void Main()
    {
        TextEditor editor = new TextEditor();
        EditorHistory history = new EditorHistory();

        history.Save(editor);
        editor.Type("Hello");
        editor.Show();

        history.Save(editor);
        editor.Type(" World");
        editor.Show();

        history.Save(editor);
        editor.MoveCursor(5);
        editor.Type(", C#");
        editor.Show();

        history.Undo(editor);
        editor.Show();

        history.Undo(editor);
        editor.Show();
    }
}