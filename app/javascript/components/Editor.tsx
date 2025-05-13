// app/javascript/components/Editor.tsx
import React, { useState, useEffect } from 'react';
import { createConsumer } from '@rails/actioncable';

interface EditorProps {
  documentId: number;
  initialContent: string;
  initialVersion: number;
}

interface Operation {
  type: 'insert' | 'delete';
  position: number;
  text?: string;
  length?: number;
  version: number;
  clientId: string;
}

const Editor: React.FC<EditorProps> = ({ documentId, initialContent, initialVersion }) => {
  const [content, setContent] = useState(initialContent);
  const [version, setVersion] = useState(initialVersion);
  const [subscription, setSubscription] = useState<any>(null);
  const clientId = Math.random().toString(36).substr(2, 9);
  
  useEffect(() => {
    // Connect to WebSocket
    const consumer = createConsumer();
    const sub = consumer.subscriptions.create(
      {
        channel: "DocumentChannel",
        id: documentId
      },
      {
        received: (data) => {
          handleOperation(data);
        }
      }
    );
    setSubscription(sub);
    
    return () => {
      sub.unsubscribe();
    };
  }, [documentId]);
  
  const handleOperation = (data: { operation: Operation }) => {
    if (data.operation.clientId === clientId) return;
    
    const op = data.operation;
    let newContent = content;
    
    if (op.type === 'insert' && op.text) {
      newContent = 
        content.slice(0, op.position) + 
        op.text + 
        content.slice(op.position);
    } else if (op.type === 'delete' && op.length) {
      newContent = 
        content.slice(0, op.position) + 
        content.slice(op.position + op.length);
    }
    
    setContent(newContent);
    setVersion(version + 1);
  };
  
  const calculateDiff = (oldContent: string, newContent: string): Operation | null => {
    if (oldContent === newContent) return null;
    
    // Find the first different character
    let i = 0;
    while (i < oldContent.length && i < newContent.length && oldContent[i] === newContent[i]) {
      i++;
    }
    
    if (newContent.length > oldContent.length) {
      // Insert operation
      return {
        type: 'insert',
        position: i,
        text: newContent.slice(i, i + (newContent.length - oldContent.length)),
        version,
        clientId
      };
    } else {
      // Delete operation
      return {
        type: 'delete',
        position: i,
        length: oldContent.length - newContent.length,
        version,
        clientId
      };
    }
  };
  
  const handleChange = (e: React.ChangeEvent<HTMLTextAreaElement>) => {
    const newContent = e.target.value;
    const diff = calculateDiff(content, newContent);
    
    if (diff) {
      subscription?.send(diff);
      setContent(newContent);
      setVersion(version + 1);
    }
  };
  
  return (
    <div className="w-full max-w-4xl mx-auto p-4">
      <div className="border rounded shadow-sm">
        <textarea 
          value={content}
          onChange={handleChange}
          className="w-full h-64 p-4 font-mono resize-none focus:outline-none"
          placeholder="Start typing..."
        />
      </div>
      <div className="mt-2 text-sm text-gray-500">
        Version: {version}
      </div>
    </div>
  );
};

export default Editor;