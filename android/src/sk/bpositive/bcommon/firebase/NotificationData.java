package sk.bpositive.bcommon.firebase;

import android.util.JsonWriter;

import java.io.IOException;
import java.io.OutputStreamWriter;
import java.io.StringWriter;

/**
 * Created by nodrock on 05/06/2017.
 */
public class NotificationData {
    private String messageId;
    private String ref;
    private String action;
    private Long actionTime;

    public NotificationData(String messageId, String ref, String action, Long actionTime) {
        this.messageId = messageId;
        this.ref = ref;
        this.action = action;
        this.actionTime = actionTime;
    }

    public String getMessageId() {
        return messageId;
    }

    public String getRef() {
        return ref;
    }

    public String getAction() {
        return action;
    }

    public Long getActionTime() {
        return actionTime;
    }

    public String toString() {
        StringWriter output = new StringWriter();

        try {
            JsonWriter writer = new JsonWriter(output);
            writer.beginObject();
            writer.name("messageId").value(messageId);
            writer.name("ref").value(ref);
            writer.name("action").value(action);
            writer.name("actionTime").value(actionTime.toString());
            writer.endObject();
            writer.close();
        } catch (IOException e) {
            e.printStackTrace();
        }

        return output.toString();
    }
}
