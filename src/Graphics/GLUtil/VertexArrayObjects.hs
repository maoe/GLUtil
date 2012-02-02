module Graphics.GLUtil.VertexArrayObjects 
  (VertexArrayObject(..), VAO, makeVAO, deleteVAO, bindVertexArray) where
import Foreign.Marshal.Array (allocaArray)
import Foreign.Marshal.Utils (with)
import Foreign.Storable (peek)
import Graphics.Rendering.OpenGL.Raw.Core31

newtype VertexArrayObject = VertexArrayObject GLuint
type VAO = VertexArrayObject

-- |Allocate a 'VertexArrayObject', and initialize it with the
-- provided action. This action should bind the buffer data, index
-- data (if necessary), and setup vertex attributes.
makeVAO :: IO () -> IO VertexArrayObject
makeVAO m = do vao <- allocaArray 1 $ \ptr -> 
                        glGenVertexArrays 1 ptr >> peek ptr
               glBindVertexArray vao
               m
               glBindVertexArray 0
               return $ VertexArrayObject vao

-- |Delete a 'VertexArrayObject'. Do not use the VAO after running
-- this action!
deleteVAO :: VertexArrayObject -> IO ()
deleteVAO (VertexArrayObject i) = with i $ glDeleteVertexArrays 1

-- |Bind a 'VertexArrayObject', or ensure that no VAO is bound.
bindVertexArray :: Maybe VertexArrayObject -> IO ()
bindVertexArray (Just (VertexArrayObject i)) = glBindVertexArray i
bindVertexArray Nothing = glBindVertexArray 0